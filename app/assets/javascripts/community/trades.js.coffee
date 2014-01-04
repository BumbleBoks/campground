# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# search fof trades

search_trades = ->
  $("#search_trade_button").click (event) ->
    orig_href = $("#search_trade_button").data('request-path')
    $("#search_trade_button").attr('href', orig_href + "/?q=" + $("#trade_search_phrase").val())

$(document).ready ->
  search_trades()

$(document).on "page:change", ->
  search_trades()
