@update_value = () ->
    $('#value').empty()
    field_type = types[$('#metadata_type').val()]
    if field_type
        if field_type.type == "select_field"
            field = $("<select name='torrent_metadatum[value]'>")
            for option in field_type.options
                opt = $("<option>")
                # opt.value(option)
                opt.val(option)
                opt.text(option)
                field.append(opt)
        $('#value').append(field)