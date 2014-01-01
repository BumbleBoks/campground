MessagePopup = function(main_div) {
	var popup_element = "<div id=\"message_popup\"><div id=\"popup_box\"><button id=\"xbutton\">x</button></div></div>";
	main_div.append(popup_element);
	this.addCloseButton(this);	
}

MessagePopup.prototype.addCloseButton = function(messagePopup) {
	$("#xbutton").bind('click', function(event) {
		event.preventDefault();
		messagePopup.close();
		messagePopup.actionButtonClicked = false;
		return
     });
};

MessagePopup.prototype.activateActionButton = function(messagePopup) {
	$("#action_button").bind('click', function(event) {
		event.preventDefault();
		messagePopup.close();
		messagePopup.actionButtonClicked = true;
		return
	});
};

MessagePopup.prototype.show = function(text) {	
	var popup = $("#message_popup #popup_box");
	popup.append("<div id=\"message_text\">" + text + "</div>");	
	popup.css("display", "block");
};

MessagePopup.prototype.showWithButton = function(text, button_text) {	
	var popup = $("#message_popup #popup_box");
	popup.append("<div id=\"message_text\">" + text + "</div>");	
	popup.append("<div id=\"action_button\">" + button_text + "</div>");	
	this.activateActionButton(this);
	popup.css("display", "block");
	this.popupClosed = false;
	this.actionButtonClicked = false;
};

MessagePopup.prototype.close = function() {
	$("#message_popup").remove();
	this.popupClosed = true;
};
