# frozen_string_literal: true

json.array! @announcements, partial: "announcements/announcement", as: :announcement
