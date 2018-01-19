class SearchField < ApplicationRecord
    enum kind: [:text_field_tag, :text_area_tag, :select_tag, :number_field_tag]
end
