json.extract! model, :id, :username, :created_at, :updated_at
json.url send("#{current_model.to_s.downcase}_url", model, format: :json)
