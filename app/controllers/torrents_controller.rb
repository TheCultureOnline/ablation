# frozen_string_literal: true

class TorrentsController < ApplicationController
  # before_action :set_torrent, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, if: -> { params[:action] == "show" && params[:format] == "torrent" }

  # GET /torrents
  # GET /torrents.json
  def index
    # @torrents = Torrent.page()
    @categories = Category.all
    # @releases = Release.search(include: [:torrents]) do
    #   fulltext params[:name] if params[:name]
    #   if params[:page]
    #     paginate page: params[:page], per_page: 10
    #   else
    #     paginate page: 1, per_page: 10
    #   end
    #   with(:category_id, params[:category_id]) if params[:category_id]
    # end.results
    @releases = Release.page(params[:page] ? params[:page].to_i : 1).per_page(10).order(:updated_at)
    @releases = @releases.where('"releases"."name" ILIKE ?', "%#{ params[:name].gsub(/\W/, '%') }%") if params[:name].present?
    @releases = @releases.where(category: params[:category]) if params[:category].present?
    category =  params[:category].present? ? params[:category] : nil
    possible_fields = params.permit(SearchField.pluck(:name)).to_hash
    fields = SearchField.where(name: possible_fields.map { |name, value| name if value.present? }.compact)
    fields = fields.where(category: [nil, category].uniq) if category
    torrent_metadata = TorrentMetadatum.select(:torrent_id)
    have_torrent_metadata = false
    fields.each do |field|
      if ["release", "all"].include? field.search_type
        @releases = @releases.where(id: ReleaseMetadatum.select(:release_id).where(name: field.name, value: params[field.name]))
      end
      if ["torrent", "all"].include? field.search_type
        torrent_metadata = torrent_metadata.where(name: field.name, value: params[field.name])
        have_torrent_metadata = true
      end
    end
    @releases = @releases.where(id: Torrent.select(:release_id).where(id: torrent_metadata)).includes(:torrents).where(torrents: { id: torrent_metadata }) if have_torrent_metadata
  end

  # GET /torrents/1
  # GET /torrents/1.json
  def show
    respond_to do |format|
      format.html {
        set_release
      }
      format.json {
        set_release
      }
      format.torrent {
        set_torrent
        unless params[:torrent_pass]
          render(plain: "", status: 400) && (return)
        end
        raw = TorrentFile.where(torrent_id: @torrent.id).first
        torrent = BEncode.load(raw.data)
        torrent["announce"] = "#{Setting.tracker_protocol}://#{Setting.tracker_hostname}:#{Setting.tracker_port }/#{params[:torrent_pass]}/announce"
        torrent["comment"] = torrent_url(@torrent.release_id, torrent_id: @torrent.id)
        send_data(torrent.bencode, filename: "#{@torrent.name}.torrent")
      }
    end
  end

  # GET /torrents/new
  def new
    @torrent = Torrent.new
    @metadata = CategoryMetadataType.order(id: :asc)
    if params[:category_id]
      @category = Category.find(params[:category_id])
    end
    if params[:release_id]
      @release = Release.find(params[:release_id])
      @torrent.release_id = params[:release_id]
      @category = @release.category
      @metadata = @metadata.where(metadata_for: CategoryMetadataType.metadata_fors[:torrent])
    end
    @metadata = @metadata.where(category: @category) if @category
  end

  # GET /torrents/1/edit
  def edit
    set_torrent
    @release = @torrent.release
    @category = @release.category
    @metadata = CategoryMetadataType.where(category: @category)
  end

  # POST /torrents
  # POST /torrents.json
  def create
    torrent = params[:torrent].delete(:torrent)
    category_id = params[:torrent].delete(:category_id)
    release = if params[:torrent][:release_id].present?
      Release.find(params[:torrent].delete(:release_id))
    else
      Release.find_or_create_by!(name: params[:torrent].delete(:name), category_id: category_id)
    end
    @torrent = Torrent.from_file(torrent.tempfile, release)
    params[:torrent].each do |name, value|
      TorrentMetadatum.create!(torrent: @torrent, name: name, value: value)
    end

    respond_to do |format|
      if @torrent.save
        format.html { redirect_to torrent_path(release), notice: "Torrent was successfully created." }
        format.json { render :show, status: :created, location: torrent_path(release) }
      else
        format.html { render :new }
        format.json { render json: @torrent.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_torrent
      @torrent = Torrent.find(params[:id])
    end

    def set_release
      @release = Release.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def torrent_params
      params.fetch(:torrent, {})
    end
end
