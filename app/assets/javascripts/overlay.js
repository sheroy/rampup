var overlay = function(){
	$("body").append('<div id="overlay" class="hide"></div><div id="overlay-message"><div class="title">Title</div><div class="message">Message</div><input type="submit" value="OK"/></div>');
}

overlay.prototype.show = function(title, message, callback){
	$("#overlay-message .title").html(title);
	$("#overlay-message .message").html(message);
	this.blockScreen();
	$("#overlay-message .title").removeClass('hide');
	$("#overlay-message input[type=submit]").bind('click', callback);
}

overlay.prototype.hide = function(){
	$("#overlay-message").addClass('hide');
	this.unblockScreen();
}

overlay.prototype.blockScreen = function(){
	$('#overlay').removeClass('hide');
}

overlay.prototype.unblockScreen = function(){
	$('#overlay').addClass('hide');
}

$(document).ready(function(){
	// var o = new overlay();
	// var title = 'Some title';
	// var message = 'This dialog is an example of the modal implementation. Clicking OK will hide this box and unblock the screen. This box can be toggled with the <b>hide</b> and <b>show</b> methods exposed via the <b>overlay</b> class.';
	// var callback = function(){
	// 	o.hide();
	// }
	// o.show(title, message, callback);
});