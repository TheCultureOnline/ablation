# frozen_string_literal: true

json.array! @models, partial: "#{current_model.to_s.underscore}", as: :user
