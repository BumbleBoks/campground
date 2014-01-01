delete_record_confirm = ->
  $("#delete_record").bind 'click', (event) ->
    popup = new MessagePopup($("body"))
    popup.showWithButton("This action can't be undone. Are you sure you want to delete?", "Yes")
    $("#delete_record").unbind('click')
    $("#delete_record").bind 'click', (event) ->
      $("#delete_record").unbind('click')
      if popup.actionButtonClicked == false
        location.reload()
      return popup.actionButtonClicked
    checkStatus = ->
      if popup.popupClosed == true
        clearInterval(waitInterval)
        $("#delete_record").click()
    waitInterval = setInterval(checkStatus, 100)
    return false


$(document).ready ->
  delete_record_confirm()

$(document).on "page:change", ->
  delete_record_confirm()

$(document).on "page:click", ->
  delete_record_confirm()