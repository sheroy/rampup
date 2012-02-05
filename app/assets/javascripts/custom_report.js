var parameters_hash = {};

function enableItem(section_header, column_name) {
    var section = $('#reporting_columns h3:contains("' + section_header + '")');
    $('li:contains("' + column_name + '")', section.next()).removeClass('disabled');
}

function separate_life_and_medical_insurance(column_name) {
    return (column_name == 'Beneficiary Name' ||
        column_name == 'Relationship with Employee' ||
        column_name == 'Percentage') ? 'Life Insurance' : 'Medical Insurance';
}

function insertRow(section_name, column_name) {
    var table = $('#selected_columns');
    var tr = document.createElement('tr');
    var td = document.createElement('td');

    $(td).html(column_name);
    $(td).attr("name", column_name);
    $(td).attr("section", section_name);
    $(td).attr("report", "true");

    var delete_link = document.createElement('td');
    var anchor = document.createElement('a');
    $(anchor).html("Delete");
    $(anchor).addClass('enabled');
    $(delete_link).append(anchor);
    $(delete_link).click(function() {
        $(tr).remove();
        enableItem($(td).attr("section"), column_name);
    });

    $(tr).append(td);
    $(tr).append(delete_link);
    table.append(tr);
}

$(function() {
    $("#selectable_columns").accordion({ autoHeight: false });

    var elements = $("#reporting_columns li")
    for (var i = 0; i < elements.length; i++) {
        $(elements[i]).attr("name", $(elements[i]).text().split(' ').join(' '));
    }

    $('#reporting_columns li').click(function() {
        var list_item = $(this);
        var section_header = list_item.parent().parent().prev();
        if (list_item.hasClass('disabled')) {
            return;
        }
        list_item.addClass('disabled');
        insertRow(section_header.text(), list_item.text());
    });
});

function generate_custom_report() {
    parameters_hash = {};
    var elements = $('#selected_columns td[report]');
    for (var i = 0; i < elements.length; i++) {
        var section_name = $(elements[i]).attr("section");
        var column_name = $(elements[i]).text();
        if (section_name == "Life and Medical Insurance") {
            section_name = separate_life_and_medical_insurance(column_name)
        }
        var value = parameters_hash[section_name];
        if (!value) {
            value = new Array();
        }
        value.push(column_name);
        parameters_hash[section_name] = value;
    }
    $("#columns_hash_").val($.toJSON(parameters_hash));
    $("#custom_report_exporter").submit();
}