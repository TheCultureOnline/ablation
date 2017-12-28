module AdminHelper
    def field_for(form, model, attr)
        puts "Attr is: #{attr}"
        puts "Type is: #{attr[1].try(:[], :type)}"
        puts "Creating a #{attr[1].try(:[], :type) || "text_field"}"
        content_tag(:div, class: "field") do
            form.label(attr[0]) +
            form.send("#{attr[1].try(:[], :type) || "text_field"}", attr[0], attr[1])
            # form.text_area(attr[0], attr[1])
        end
    end
end
