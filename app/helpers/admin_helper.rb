# frozen_string_literal: true

module AdminHelper
  def admin_field_for(form, model, attr)
    content_tag(:div, class: "field") do
      if attr[1][:format]
        attr[1][:value] = model.send(attr[0]).send(attr[1][:format][0], *attr[1][:format][1..-1]) unless model.send(attr[0]).nil?
      end
      # binding.pry
      form.label(attr[0]) +
      form.send("#{attr[1].try(:delete, :type) || "text_field"}", attr[0], attr[1])
      # form.text_area(attr[0], attr[1])
    end
  end
end
