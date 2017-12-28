module AdminHelper
    def field_for(form, model, attr)
        content_tag(:div, class: "field") do
            form.label(attr[0]) +
            form.send("#{attr[1].try(:type) || "text"}_field", attr[0], attr[1])
        end
    end
end
