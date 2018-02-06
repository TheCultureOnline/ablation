# frozen_string_literal: true

require "net/http"

class Importer
  def initialize(base_url, **keyword_args)
    @base_url = base_url
    @torrent = keyword_args[:torrent]
    @detail = keyword_args[:detail] || "#{@torrent}?torrentid=%s"
    @login = keyword_args[:login]
    @login_check = keyword_args[:login_check] || @login
    @search = keyword_args[:search]
    @user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0) Gecko/20100101 Firefox/45.0"
    @cookies = ""

    login
  end

  def login_params
    {}
  end

  def login
    return true if login_check
    output = request(@login, login_params.to_query)

    if login_success? output
      all_cookies = output.get_fields("set-cookie")
      cookies_array = Array.new
      all_cookies.each { | cookie |
        cookies_array.push(cookie.split("; ")[0])
      }
      @cookies = cookies_array.join("; ")
      true
    else
      false
    end
  end

  def login_check
    login_success? request(@login_check)
  end

  def login_success?(response)
    true
  end

  def uri(part)
    URI(
      [@base_url, part].join("/")
    )
  end

  def request(url, data = nil, query = nil)
    parsed_url = uri(url)
    parsed_url.query = query if query
    headers = {}
    headers["Referer"] = "#{parsed_url.scheme}://#{parsed_url.host}"
    headers["User-Agent"] = @user_agent
    # headers['Accept-encoding'] = 'gzip'
    headers["Connection"] = "keep-alive"
    headers["Cache-Control"] = "max-age=0"
    headers["Cookie"] = @cookies
    http = Net::HTTP.new(parsed_url.host, parsed_url.port)
    if data.nil? || data.length == 0
      request = Net::HTTP::Get.new(parsed_url.request_uri, headers)
    else
      request = Net::HTTP::Post.new(parsed_url.request_uri, headers)
    end
    request.body = data if data
    http.use_ssl = parsed_url.scheme == "https"
    http.request(request)
  end
end
