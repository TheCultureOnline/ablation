# frozen_string_literal: true

module TorrentsHelper
  def field_for(attr)
    puts "About to make a field for : #{attr}"
    # attr should be an array of fields, with the structure:
    # [ name, type, [options] ]
    content_tag(:div, class: "field") do
      # This is a text field
      label_tag(attr[0]) + if attr[2].nil?
                             text_field_tag(attr[0])
                           else # options is non nil
                             select_tag(attr[0], options_for_select(attr[2]))
                           end
    end
  end
end
