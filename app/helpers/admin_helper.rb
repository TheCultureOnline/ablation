# frozen_string_literal: true

module AdminHelper
  def field_for(form, model, attr)
    content_tag(:div, class: "field") do
      form.label(attr[0]) +
      form.send("#{attr[1].try(:[], :type) || "text_field"}", attr[0], attr[1])
      # form.text_area(attr[0], attr[1])
    end
  end
end
