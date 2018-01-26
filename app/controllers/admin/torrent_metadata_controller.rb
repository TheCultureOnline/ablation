# frozen_string_literal: true

class Admin::TorrentMetadataController < AdminController
  before_action :set_torrent

  def index
    super
    @models = @models.where(torrent: @torrent)
  end

  protected

    def respond_to_saved(format, saved)
      if saved
        format.html { redirect_to admin_torrent_path(@torrent), notice: "#{current_model.to_s} was successfully updated." }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
      end

    def set_torrent
      @torrent = Torrent.find(params[:torrent_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      p = params.require(:torrent_metadatum).permit(:name, :value)
      p[:torrent_id] = params.require(:torrent_id)
      p
    end

    def current_model
      TorrentMetadatum
    end

    def model_attributes
      [
          [:name, { type: "text_field" }],
          [:value, { type: "text_field" }],
      ]
    end

    def nav_links
      [
          ["List", [:admin, :torrent_torrent_metadata]],
          ["New", [:new, :admin, :torrent_torrent_metadatum]]
      ]
    end

    def show_path_parts(model)
      [:admin, @torrent, model]
    end

    def edit_path_parts(model)
      [:edit, :admin, @torrent, model]
    end

    def new_path_parts
      [:new, :admin, @torrent, current_model.to_s.underscore]
    end
end
