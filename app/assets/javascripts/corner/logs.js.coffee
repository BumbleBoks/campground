# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# this loads the calendar and sets the date for log

load_date_picker = ->
  userDate = null;

  dateString =  $("#corner_log_log_date").attr("value") || $("#corner_log_log_date").html() 
  datearray = dateString.split("-")

  userDate = new Date()
  userDate.setFullYear(datearray[0])
  userDate.setMonth(datearray[1]-1)
  userDate.setDate(datearray[2])

  $("#corner_log_log_date").bind 'date_change', (event) ->
    selectedDate = datePicker.selectedDate
    year = selectedDate.getFullYear()
    month = selectedDate.getMonth() + 1
    day = selectedDate.getDate()
    new_url = ['/corner/logs', year, month, day].join('/')
    $.ajax
      url: new_url
      type: 'GET'
      dataType: "script"
      complete: () -> 
        load_date_picker() 
        update_log_tags()

  if !datePicker
    $("#date_picker").empty()
    datePicker = new DatePicker
    datePicker.initialize($("#date_picker"), $("#corner_log_log_date"), userDate)

load_log_picker = ->
  datesArray = $("#read_log_button").data('log-dates')
  monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", \
    "September", "October", "November", "December"]  

  $("#read_log_button").click (event) ->
    $("#corner_log_log_date").bind 'date_selected', (event) ->
      dateIndex = logPicker.selectedIndex
      selectedDateText = datesArray[dateIndex]  
      firstArray = selectedDateText.split(",")
      selectedDateArray = firstArray[1].trim().split(" ").filter((el) -> return el != "")
      new_url = ['/corner/logs', selectedDateArray[2], monthArray.indexOf(selectedDateArray[0]) + 1, \
        selectedDateArray[1]].join('/')
      $.ajax
        url: new_url
        type: 'GET'
        dataType: "script"
        complete: () -> 
          load_date_picker() 
          update_log_tags()

    if !logPicker
      emptyMessage = "There are no saved logs."
      logPicker = new ItemPicker
      logPicker.initialize($("body"), datesArray, emptyMessage, $("#corner_log_log_date"))
      return false

logs_load = ->
  load_date_picker()
  load_log_picker()

# this updates tags for the log
update_log_tags = ->
  $("#add_log_tag").click (event) ->
    event.preventDefault()
    new_tag = $("#corner_log_tags_attributes_0_name").val().trim(" ", "\t", "\n")
    $("#corner_log_tags_attributes_0_name").val("")
    tag_names = $("li input")
    dup_tag_name = false
    dup_tag_name = true for tag in tag_names when $(tag).val() is new_tag

    if dup_tag_name == true
      popup = new MessagePopup($("body"))
      popup.show("This tag has already been added")
    else
      count = Date.now()
      input_string = "<input id=\"corner_log_tags_attributes_#{count}_name\" type=\"hidden\" 
        value=\"#{new_tag}\" name=\"corner_log[tags_attributes][#{count}][name]\">"
      link_string = ' <a id="delete_log_tag" class="log_tag_button" href="#">x</a>'
      append_string = input_string + new_tag + link_string
      $("#log_tags ul").append("<li></li>")
      $("#log_tags li").last().append(append_string)

  $('#log_tags ul').on 'click', $("a#delete_log_tag"), (event) ->
    $(event.target).closest('li').remove()


$(document).on "page:load", ->
  logs_load()

$(document).ready ->
  logs_load()
  update_log_tags()

$(document).on "page:change", ->
  update_log_tags()
