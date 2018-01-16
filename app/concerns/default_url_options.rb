# frozen_string_literal: true

module DefaultUrlOptions
  # Including this file sets the default url options. This is useful for mailers or background jobs

  def default_url_options
    {
      host: host,
      port: port
    }
  end

private

  def host
    # Your logic for figuring out what the hostname should be
    Setting.site_hostname
  end

  def port
    # Your logic for figuring out what the port should be
    Setting.site_port
  end
end
