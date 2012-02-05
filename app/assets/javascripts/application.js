// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

window.onload = function () {
    $("#sortable").tablesorter();
    paths = window.location.pathname.split("/");
    if (paths[1] == "user" && paths[2] == "login") {
        document.getElementById("username").focus();
    }

    if (paths[1] == "profile" && paths[2] == "edit") {
        if (check_address()) {
            document.getElementById("address_chk").checked = true;
            set_permanent_element_readonly();
        }
    }
    if (include(paths, "visa")) {
        set_readonly_based_on_visa_type();
    }


    if (window.location.pathname == 'profile/new') {
        document.getElementById("profile_last_day_1i").setAttribute("readonly", true);
        document.getElementById("profile_last_day_2i").setAttribute("readonly", true);
        document.getElementById("profile_last_day_3i").setAttribute("readonly", true);
    }


    $("#rm_search_results").height($(window).height() - $("#logo").height() - $("#menu").height() - 100);
    $("#rm_search_results").width($("#content").width() - 50);
    copy_address();

}
var include = function(array, value) {
    for (var i in array) {
        if (array[i] == value) {
            return true;

        }
    }
    return false;
}

var copy_address = function() {
    if ($("#address_chk").attr('checked')) {
        copy_info_from_current_to_permanent();
        set_permanent_element_readonly();
    }
    else {
        unset_permanent_element_readonly();
    }
}

var copy_info_from_current_to_permanent = function() {
    $("#profile_permanent_address_line_1").val($("#profile_temporary_address_line1").val());
    $("#profile_permanent_address_line2").val($("#profile_temporary_address_line2").val());
    $("#profile_permanent_address_line3").val($("#profile_temporary_address_line3").val());
    $("#profile_permanent_city").val($("#profile_temporary_city").val());
    $("#profile_permanent_state").val($("#profile_temporary_state").val());
    $("#profile_permanent_pincode").val($("#profile_temporary_pincode").val());
}

var validate_phone_number = function(obj) {
    val = obj.value
    len = val.length
    if (isNaN(obj.value) || (obj.value.charCodeAt(len - 1) == 32)) {
        val = val.substring(0, val.length - 1);
        obj.value = val;
        return false;
    }
    return true;
}

var populate_degree = function() {
    category = document.getElementById("qualification_category").value
    if (category == "UG-Engineering")
        document.getElementById("qualification_degree").value = ["BE","BTech"]
}

var concat_name = function() {
    document.getElementById("profile_common_name").value = document.getElementById("profile_name").value + " " + document.getElementById("profile_surname").value;
}
var set_permanent_element_readonly = function() {
    set_element_readonly($("#profile_permanent_address_line_1"));
    set_element_readonly($("#profile_permanent_address_line2"));
    set_element_readonly($("#profile_permanent_address_line3"));
    set_element_readonly($("#profile_permanent_city"));
    set_element_readonly($("#profile_permanent_pincode"));
    set_element_disabled($("#profile_permanent_state"));
}

var set_element_disabled = function(element) {
    element.attr('disabled','disabled');
    element.css('background-color', '#CCC');
}

var unset_element_disabled = function(element) {
    element.removeAttr('disabled');
}

var set_element_readonly = function(element) {
    element.attr('readonly', true);
    element.css('background-color', '#CCC');
}

var unset_element_readonly = function(element) {
    element.removeAttr('readonly');
    element.css('background-color', '#FFFFFF');
}

var unset_permanent_element_readonly = function() {
    unset_element_readonly($("#profile_permanent_address_line_1"));
    unset_element_readonly($("#profile_permanent_address_line2"));
    unset_element_readonly($("#profile_permanent_address_line3"));
    unset_element_readonly($("#profile_permanent_city"));
    unset_element_readonly($("#profile_permanent_pincode"));
    unset_element_disabled($("#profile_permanent_state"));
}

var check_address = function() {
    if (document.getElementById("profile_permanent_address_line_1").value == document.getElementById("profile_temporary_address_line1").value
        && document.getElementById("profile_permanent_address_line2").value == document.getElementById("profile_temporary_address_line2").value
        && document.getElementById("profile_permanent_address_line3").value == document.getElementById("profile_temporary_address_line3").value
        && document.getElementById("profile_permanent_city").value == document.getElementById("profile_temporary_city").value
        && document.getElementById("profile_permanent_state").value == document.getElementById("profile_temporary_state").value
        && document.getElementById("profile_permanent_pincode").value == document.getElementById("profile_temporary_pincode").value)
        return true;
    else
        return false;
}


//for disabling the elemnets based on the type of visa
var set_readonly_based_on_visa_type = function() {
    category = document.getElementById("visa_category").value;
    unset_readonly_all();
    if (category == "US H1B") {
        elements = ["visa_country","visa_date_of_return_1i" ,"visa_date_of_return_2i" ,"visa_date_of_return_3i" ,"visa_travel_by_1i","visa_travel_by_2i","visa_travel_by_3i","visa_reason","visa_visa_type"];
    }
    else if (category == "UK - Work Permit") {
        elements = ["visa_country","visa_reason","visa_appointment_date_1i","visa_appointment_date_2i","visa_appointment_date_3i","visa_timeline","visa_petition_status"];
    }
    else if (category == "Schengen") {
        elements = ["visa_appointment_date_1i","visa_appointment_date_2i","visa_appointment_date_3i","visa_timeline","visa_petition_status","visa_date_of_return_1i" ,"visa_date_of_return_2i" ,"visa_date_of_return_3i" ,"visa_travel_by_1i","visa_travel_by_2i","visa_travel_by_3i","visa_reason","visa_visa_type"]
    }
    else if (category == "Australian - Business" || category == "Australian - Work Permit") {
        elements = ["visa_appointment_date_1i","visa_appointment_date_2i","visa_appointment_date_3i","visa_timeline","visa_petition_status","visa_country","visa_date_of_return_1i" ,"visa_date_of_return_2i" ,"visa_date_of_return_3i" ,"visa_travel_by_1i","visa_travel_by_2i","visa_travel_by_3i","visa_reason"]
    }
    else if (category == "US B1" || category == "US L1A" || category == "US L1B" || category == "UK - Business") {
        elements = ["visa_appointment_date_1i","visa_appointment_date_2i","visa_appointment_date_3i","visa_timeline","visa_petition_status","visa_country","visa_date_of_return_1i" ,"visa_date_of_return_2i" ,"visa_date_of_return_3i" ,"visa_travel_by_1i","visa_travel_by_2i","visa_travel_by_3i","visa_reason","visa_visa_type"]
    }
    else if (category == "") {
        elements = []
    }
    else {
        elements = ["visa_appointment_date_1i","visa_appointment_date_2i","visa_appointment_date_3i","visa_timeline","visa_petition_status","visa_country","visa_date_of_return_1i" ,"visa_date_of_return_2i" ,"visa_date_of_return_3i" ,"visa_travel_by_1i","visa_travel_by_2i","visa_travel_by_3i","visa_visa_type"]
    }
    readonly_of(elements);
}
var readonly_of = function(elements) {
    for (i = 0; i < elements.length; i++) {
        document.getElementById(elements[i]).disabled = true
    }
}

var unset_readonly_all = function() {
    document.getElementById("visa_reason").disabled = false
    document.getElementById("visa_visa_type").disabled = false
    document.getElementById("visa_appointment_date_1i").disabled = false
    document.getElementById("visa_appointment_date_2i").disabled = false
    document.getElementById("visa_appointment_date_3i").disabled = false
    document.getElementById("visa_travel_by_1i").disabled = false
    document.getElementById("visa_travel_by_2i").disabled = false
    document.getElementById("visa_travel_by_3i").disabled = false
    document.getElementById("visa_date_of_return_1i").disabled = false
    document.getElementById("visa_date_of_return_2i").disabled = false
    document.getElementById("visa_date_of_return_3i").disabled = false
    document.getElementById("visa_petition_status").disabled = false
    document.getElementById("visa_timeline").disabled = false
    document.getElementById("visa_country").disabled = false
}


var key;
var combo;

var select_box = function(e) {
    if (combo && combo.editing && window.event && window.event.keyCode == 8) {
        window.event.cancelBubble = true;
        window.event.returnValue = false;
        if (combo.insertSpace) {
            combo.insertSpace = false;
        }
        else {
            with (combo.options[combo.options.length - 1]) {
                text = text.substring(0, text.length - 1);
            }
        }
    }
}
var remove_watermark = function(elem) {
    if (elem.value == "Employee Search" || elem.value == "Project Search") {
        elem.className = "";
        elem.value = "";
    }
}

var add_watermark = function(elem) {
    if (elem.value == "") {
        if (elem.name == "search_terms" || elem.name == "search[name]")
            elem.value = "Employee Search";
        else
            elem.value = "Project Search";
    }
}

var edit = function(e) {
    if (window.event) {
        key = window.event.keyCode;
        combo = window.event.srcElement;
        // Stop the browser from scrolling through <option>s
        window.event.cancelBubble = true;
        window.event.returnValue = false;
    }
    else if (e) {
        key = e.which;
        combo = e.target;
    }
    else {
        return true;
    }

    if (key == 13 || key == 8 || (key > 31 && key < 127)) {
        if (combo.editing && key == 13) {
            // Done editing
            combo.editing = false;
            combo = null;
            return false;
        }
        else if (!combo.editing) {
            combo.editing = true;
            combo.options[combo.options.length] = new Option("");
        }

        // Normal key
        if (key > 32 && key < 127) {
            with (combo.options[combo.options.length - 1]) {
                if (combo.insertSpace) {
                    combo.insertSpace = false;
                    text = text + " " + String.fromCharCode(key);
                }
                else {
                    text = text + String.fromCharCode(key);
                }
            }
        }
        // The backspace key
        else if (key == 8 && combo.options[combo.options.length - 1].text.length) {
            if (combo.insertSpace) {
                combo.insertSpace = false;
            }
            else {
                with (combo.options[combo.options.length - 1]) {
                    text = text.substring(0, text.length - 1);
                }
            }
        }
        // Space key requires special treatment; some browsers will not append a space
        else if (key == 32) {
            combo.insertSpace = true;
        }
        combo.selectedIndex = combo.options.length - 1;
        return false;
    }
}

var close_dialog = function(id) {
    $("#pop_up_overlay").hide();
    $("#pop_up_content_" + id).hide();
}

var validate_dialog = function() {
    if (($("#profile_last_day_1i").val() == "") || ($("#profile_last_day_2i").val() == "") || ($("#profile_last_day_3i").val() == "")) {
        $("span.error").show();
        return false;
    }
    return true;
}

var invoke_pop_up = function(id) {
    $("#pop_up_overlay").height($("#content").height());
    $("#pop_up_overlay").show();
    $("#pop_up_content_" + id).show();
    $("#pop_up_content_" + id).css('left', ($("body").width() - 425) / 2);
    $("#pop_up_content_" + id).css('top', $("#content").height() - 400);
}

var show_element = function(id) {
    $("#" + id).show()
}
var hide_element = function(id) {
    $("#" + id).hide()
}


var validate_date = function(name, message) {
    year = "#" + name + "_3i";
    month = "#" + name + "_2i";
    day = "#" + name + "_1i";

    if($(year).val() == "" ||
    $(month).val() == "" ||
    $(day).val() == "")
      return message;
    return "";
}

var date_form_validation = function (submit_button) {
    $("#" + submit_button + "_submit").click(function() {
        var error_message = "";

        error_message += validate_date(submit_button + "_date_of_issue", "Date of Issue required.\n");

        error_message += validate_date(submit_button + "_date_of_expiry", "Date of Expiry required.\n");

        if (error_message != "") {
          alert(error_message);
          return false;
        }
    });
}

$(function(){
	date_form_validation("passport");
	date_form_validation("dependent_passport");
}); 