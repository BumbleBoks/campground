# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# autocomplete for search input
search_trail_autocomplete = ->
  $("#search_trail").autocomplete
    source: $("#search_trail").data('autocompleteSource')
    select: (event, ui) ->
      $('#search_button').click()
  $('#search_button').click (event) ->
    orig_href = $('#search_button').data('request-path')
    #orig_href = $('#search_button').attr('href')
    $('#search_button').attr('href', orig_href + $("#search_trail").val())
    return true

# show the button associated with the select_trail partial
show_trail_buttons = ->
  $('#select_trail_button').show()

# hide the button associated with the select_trail partial
hide_trail_buttons = ->
  $('#select_trail_button').hide()

# show options based on state and activity selection
set_trail_html = (trails) ->
  activity = $('#activity_id :selected').text()
  state = $('#state_id :selected').text()
  if activity == 'Select an activity' && state == 'Select a state'
  else if activity == 'Select an activity' || state == 'Select a state'
    $('#trails_found').empty()
    $("#search_trail").val("")
  else
    options = $(trails).filter("optgroup[label='#{state},#{activity}']").html()
    
  if options 
    $('#trail_id').html(options)
    $('#trail_id').show()
    show_trail_buttons()
    $('#trail_selection_message').hide()
  else
    $('#trail_id').hide()
    hide_trail_buttons()
    $('#trail_selection_message').show()	

page_load = ->
  search_trail_autocomplete()	
  trails = $('#trail_id').html()
  $('#trail_id').hide()
  hide_trail_buttons()
  $('#trail_selection_message').hide()

  $('#state_id').change ->
    set_trail_html(trails)

  $('#activity_id').change ->
    set_trail_html(trails)

  $('#get_updates_button').click (event) ->
    event.preventDefault()
    trail_id = $('#trail_id :selected').val()
    orighref = $('#get_updates_button').data('request-path')
    $.ajax
      url: orighref
      type: 'GET'
      dataType: "script"
      data: trail_id: trail_id    

  $('#show_trail_button').click (event) ->
    event.preventDefault()
    trail_id = $('#trail_id :selected').val()
    trail_name = $('#trail_id :selected').html()
    state_name = $('#state_id :selected').html()
#    new_url = ['/common/trails', trail_id].join('/')
    trail_link = [trail_name, state_name].join(',')
    new_url = ['/common/trails', trail_link].join('/')
    location.replace new_url
       
$(document).ready ->
  page_load()

$(document).on "page:change", ->
  page_load()


