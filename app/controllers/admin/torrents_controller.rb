class TorrentsController < AdminController
  protected
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def model_params
    params.require(:torrent).permit_all()
  end

  def current_model
    Torrent
  end

  def model_attributes
    [
        [:name, {type: "text_field"}],
        [:description, {type: "text_area"}],
    ]
  end

  def nav_links
    [
        ["List", [:admin, :torrents]],
        ["New", [:new, :admin, :torrent]]
    ]
  end
end
