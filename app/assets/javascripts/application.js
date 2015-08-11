// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-fileupload
//= require turbolinks
//= require_tree .

var fileUploadErrors = {
  maxFileSize: 'File is too big',
  minFileSize: 'File is too small',
  acceptFileTypes: 'Filetype not allowed',
  maxNumberOfFiles: 'Max number of files exceeded',
  uploadedBytes: 'Uploaded bytes exceed file size',
  emptyResult: 'Empty file upload result'
};

$(function(){
	$('.comment').keypress(function(e){
		var keycode = (e.keyCode ? e.keyCode : e.which);
    if (keycode == '13') {
    	$this = $(this)
      $.ajax({
						  method: "POST",
						  url: "/comment/add",
						  data: { id_photo: $(this).attr("id-photo"), message: $(this).val() },
						  asyn: false,
						  success:function(msg){
						  	$this.parent().find('.comment-list').prepend(msg);
						  }
						});
    }
	});

	$('#keyword').keypress(function(e){
		var keycode = (e.keyCode ? e.keyCode : e.which);
    if (keycode == '13') {
    	location.href = "/photo/feeds?keyword=" + $(this).val().replace("#", " ");;
    }
	});
});