class TorrentsController < ApplicationController
  before_action :set_torrent, only: [:show, :edit, :update, :destroy]

  # GET /torrents
  # GET /torrents.json
  def index
    # @torrents = Torrent.all
    @categories = Category.all
    @metadata = CategoryMetadatum.pluck(:name, :data_type, :options)
  end

  # GET /torrents/1
  # GET /torrents/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.torrent {
        unless params[:torrent_pass]
          render plain: "", :status => 400 and return
        end
        raw = TorrentFile.where(torrent_id: @torrent.id).first
        torrent = BEncode.load(raw.data)
        torrent['announce'] = "#{Setting.tracker_url}/#{params[:torrent_pass]}/announce"
        send_data( torrent.bencode, :filename => "#{@torrent.name}.torrent" )
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
    raw = File.read(torrent.tempfile)
    torrent = BEncode.load(raw)


    # The following properties do not affect the infohash:
    # anounce-list is an unofficial extension to the protocol
    # that allows for multiple trackers per torrent
    torrent['info'].delete('announce-list')
    # Bitcomet & Azureus cache peers in here
    torrent['info'].delete('nodes')
    # Azureus stores the dht_backup_enable flag here
    torrent['info'].delete('azureus_properties')
    # Remove web-seeds
    torrent['info'].delete('url-list')
    # Remove libtorrent resume info
    torrent['info'].delete('libtorrent_resume')
    torrent['info']['private'] = 1
  
    torrent_file = TorrentFile.create!(torrent: @torrent, data: torrent.bencode)

    @torrent = Torrent.new(torrent_params)
    @torrent.size = torrent['info']['length']
    @torrent.name = torrent['info']['name']
    @torrent.info_hash = torrent_file.info_hash
    # Setup file lists
    if torrent['info']['name']
      @torrent.file_list << torrent['info']['name']
    end
    if torrent['info']['files']
      torrent['info']['files'].each do |f|
        @torrent.file_list << f['path']
      end
    end
    @torrent.save

    respond_to do |format|
      if @torrent.save
        format.html { redirect_to @torrent, notice: 'Torrent was successfully created.' }
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
