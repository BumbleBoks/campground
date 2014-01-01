add_missing_trail_form = ->
  $("#missing_trail_form").hide()
  $("#missing_trail_link").click (event) ->
    event.preventDefault()
    $("#common_missing_trail_info").val("")
    $("#missing_trail_form").show()

process_missing_trail_form = ->    
  $("#add_missing_trail").click (event) ->
    if $("#common_missing_trail_info").val().trim() == ""
      $("#common_missing_trail_info").val("")
      return false
    else
      $("#missing_trail_form").hide() 
      return true

$(document).ready ->
  add_missing_trail_form()

$(document).on "page:change", ->
  add_missing_trail_form()

$(document).on "click", ->
  process_missing_trail_form()