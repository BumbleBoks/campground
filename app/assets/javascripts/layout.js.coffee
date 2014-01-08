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

use_current_date_for_log = ->
  date = new Date()
  orig_href = $(".diary_board a").attr("href")
  href_components = orig_href.split("/")
  href_length = href_components.length
  href_components[href_length - 3] = date.getFullYear() 
  href_components[href_length - 2] = date.getMonth() + 1
  href_components[href_length - 1] = date.getDate() 
  $(".diary_board a").attr("href", href_components.join("/"))

$(document).ready ->
  refresh_page_if_needed()
  use_current_date_for_log()

$(document).on "page:change", ->
  refresh_page_if_needed()  

$(document).ajaxComplete (event, request) ->
  check_for_flash_messages(request)