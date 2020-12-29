// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require select2

document.addEventListener("turbolinks:load", function() {
  $(".select_two").select2({
    theme: "bootstrap"
  });

  $('.follow-btn').click(function() {
    var followable_type = $(this).data('followable_type');
    var followable_id = $(this).data('followable_id');
    var follow_action = $(this).data('follow_action');
    $.ajax({
      type: 'POST',
      url: '/follow_update',
      data: { 'followable_type': followable_type, 'followable_id': followable_id, 'follow_action': follow_action },
      dataType: "script",
      success: function () {
      },
      error: function () {
      }
    });
  });

  $('.login-click').click(function() {
    showModalPopUp('login_modal');    
  });

  function showModalPopUp(obj){
    $(".modal").modal("hide");
    $("#"+obj).modal('show');
  };

});
