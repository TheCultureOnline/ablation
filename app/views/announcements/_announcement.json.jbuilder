# frozen_string_literal: true

json.extract! announcement, :id, :title, :body, :user_id, :created_at, :updated_at
json.url announcement_url(announcement, format: :json)
