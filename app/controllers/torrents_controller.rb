# frozen_string_literal: true

class TorrentsController < ApplicationController
  before_action :set_torrent, only: [:show, :edit, :update, :destroy]

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
    @releases = Release.page(params[:page] ? params[:page].to_i : 1).per_page(10).includes(:torrents)
    @releases = @releases.where('"releases"."name" ILIKE ?', "%#{ params[:name] }%") if params[:name]
    @releases = @releases.where(year: params[:year]) if params[:year]
  end

  # GET /torrents/1
  # GET /torrents/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.torrent {
        unless params[:torrent_pass]
          render(plain: "", status: 400) && (return)
        end
        raw = TorrentFile.where(torrent_id: @torrent.id).first
        torrent = BEncode.load(raw.data)
        torrent["announce"] = "#{Setting.tracker_url}/#{params[:torrent_pass]}/announce"
        send_data(torrent.bencode, filename: "#{@torrent.name}.torrent")
      }
    end
  end

  # GET /torrents/new
  def new
    @torrent = Torrent.new
  end

  # GET /torrents/1/edit
  def edit
  end

  # POST /torrents
  # POST /torrents.json
  def create
    torrent = params[:torrent].delete(:torrent)
    category_id = params[:torrent].delete(:category_id)
    @torrent = Torrent.from_file(torrent.tempfile, category_id)

    respond_to do |format|
      if @torrent.save
        format.html { redirect_to @torrent, notice: "Torrent was successfully created." }
        format.json { render :show, status: :created, location: @torrent }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def torrent_params
      params.fetch(:torrent, {})
    end
end
