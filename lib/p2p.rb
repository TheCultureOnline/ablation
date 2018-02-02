require 'importer'

class P2P < Importer
    def initialize username, password, key
        @username = username
        @password = password
        @key = key
        super(
            "https://passthepopcorn.me",
            torrent: "torrents.php",
            login: "ajax.php?action=login",
            search: "search/%s/0/7/%d",
        )
    end

    def search(query)
        params = {
            json: "noredirect",
            order_by: "relevance",
            order_way: "descending",
        }
        params[:searchstr] = query if query
        resp = request(@torrent, nil, params.to_query)
        binding.pry
        resp.body
    end

    def login_params
        {
            'username': @username,
            'password': @password,
            'passkey': @key,
            'keeplogged': '1',
            'login': 'Login'
        }
    end

    def login_success? output
        begin
            res = JSON.parse output.body
            res['Result'].downcase == "ok"
        rescue
            return false
        end
    end
end