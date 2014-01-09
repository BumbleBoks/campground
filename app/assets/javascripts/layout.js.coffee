refresh_page_if_needed = ->
#  lastLoadDateStr = window.document.lastModified
  lastLoadDateStr = $("#last_loaded").text()
  date = new Date()
  dateStr = lastLoadDateStr.split("-") 
  yearStr = dateStr[2].split(" ")
  timeStr = yearStr[1].split(":") 
  lastLoaded = new Date(Date.UTC(dateStr[0], dateStr[1] - 1, yearStr[0], timeStr[0], timeStr[1], timeStr[2]))
  if (date - lastLoaded) > 30000
    location.reload()

check_for_flash_messages = (request) ->
  flash_message = request.getResponseHeader('X-Message')
  flash_type = request.getResponseHeader('X-Message-Type')
  if flash_type != null
    $("#flash_messages").html("<div class = 'flash_" + flash_type + "'>" + flash_message + '</div')
    $(".flash_"+flash_type).delay(5000).slideUp

close_side_menu = (side_div) ->
  side_div.css("width", "20px")
  side_div.css("z-index", "0")
  side_div.css("background-color", " rgba(170, 124, 62, 0.7)")

open_side_menu = (side_div) ->
  side_div.css("width", "200px")
  side_div.css("z-index", "5")
  side_div.css("background-color", " rgba(170, 124, 62, 1.0)")

add_click_to_display = ->
  $("#user_dynamic").on 'click', (event) ->
    if $("#user_individual").width() < $(".favorites_board").width() || 
    $("#user_community").width() < $(".trails_board").width()
      close_side_menu($("#user_individual"))    
      close_side_menu($("#user_community"))

side_menu_slide = ->
  $("#user_individual").bind 'click', (event) ->
    if $("#user_individual").width() < $(".favorites_board").width()
      open_side_menu($("#user_individual"))
      close_side_menu($("#user_community"))

  $("#user_community").bind 'click', (event) ->
    if $("#user_community").width() < $(".trails_board").width()
      open_side_menu($("#user_community"))
      close_side_menu($("#user_individual"))

setup_for_no_hover = ->
  side_menu_slide()
  add_click_to_display()

$(document).ready ->
  refresh_page_if_needed()
  setup_for_no_hover()

$(document).on "page:change", ->
  refresh_page_if_needed()  
  setup_for_no_hover()

$(document).ajaxComplete (event, request) ->
  check_for_flash_messages(request)
