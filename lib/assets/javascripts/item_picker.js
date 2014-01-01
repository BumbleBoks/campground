ItemPicker = function() {
	this.itemPickerOuterDiv = null;
	this.itemsArray = null;
	this.emptyMessage = "None found"
	this.itemSelectionDiv = null;
	this.selectedIndex = null;
}

ItemPicker.prototype.initialize = function(mainDiv, itemsArray, itemSelectionDiv) {
	this.pickerOuterDiv = mainDiv;
	this.itemsArray = itemsArray; 
	this.displayItemPicker();
	this.itemSelectionDiv = itemSelectionDiv;
	this.displayItemPicker();
}

ItemPicker.prototype.initialize = function(mainDiv, itemsArray, emptyMessage, itemSelectionDiv) {
	this.pickerOuterDiv = mainDiv;
	this.itemsArray = itemsArray; 
	this.emptyMessage = emptyMessage;
	this.itemSelectionDiv = itemSelectionDiv;
	this.displayItemPicker();
}

ItemPicker.prototype.displayItemPicker = function(itemsArray) {
	var item_picker = "<div id=\"picker_popup\"><div id=\"item_picker\"><button id=\"xbutton\">x</button></div></div>";
	this.pickerOuterDiv.append(item_picker);
	this.addItemsList(this);
	this.addCloseButton(this);
}

ItemPicker.prototype.addItemsList = function(itemPicker) {
	if (this.itemsArray.length === 0) {
		$("#item_picker").append("<p>" + this.emptyMessage + "</p>");
		return;
	}
	for (var i in this.itemsArray) {
		$("#item_picker").append("<li id=" + i + ">" + this.itemsArray[i] + "</li>");	
		$("#item_picker li#"+i).bind("click", function(event) {
			itemPicker.selectedIndex = this.id;
			itemPicker.itemSelectionDiv.trigger('date_selected');		
			itemPicker.close();
		});    
	}
}

ItemPicker.prototype.addCloseButton = function(itemPicker) {
	$("#xbutton").bind('click', function(event) {
		event.preventDefault();
		itemPicker.close();
		return
     });
}

ItemPicker.prototype.close = function() {
	$("#picker_popup").remove();
}


// function enter_popup(event) {
//     console.log("mouse entered")
// }
// 
// function leave_popup(event) {
//     console.log("mouse left")
// }
// 
// $("#color_picker_popup").hover(enter_popup, leave_popup)
// 
// DatePicker = function() {
// 	this.datePicker = null;
// 	this.daysArray = null;
// 	this.monthsArray = null;
// 	this.selectedIndex = null;
// 	this.selectedDate = null;
// 	this.centralDate = null;
// 	this.displayDate = null;
// }
// 
// DatePicker.prototype.initialize = function(datePickerDiv, displayDateDiv, userDate) {
// 	this.datePicker = datePickerDiv;
// 	this.displayDate = displayDateDiv;
// 	this.centralDate = userDate || new Date();
// 	this.setDaysAndMonthsArray();
// 	this.setDatePickerHtml();
// 	this.setWithCentralDate(this);
// 	this.selectDateColumn(3);
// }
