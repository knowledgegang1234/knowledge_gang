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
//= require jquery.easy-autocomplete
//= require search

document.addEventListener("turbolinks:load", function() {

  setTimeout(function() {
    $('.alert').fadeOut('slow');
  }, 3000);

  $(".select_two").select2({
    theme: "bootstrap"
  });

  var tagsname = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
      url: '/tags-name-list',
      filter: function(list) {
        return $.map(list, function(tagname) {
          return { name: tagname }; });
      }
    }
  });
  tagsname.initialize();

  $('.tag-select').tagsinput({
    typeaheadjs: {
      name: 'tagsname',
      displayKey: 'name',
      valueKey: 'name',
      source: tagsname.ttAdapter()
    }
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
    login()
  });

  $('.login-click').on('hidden.bs.modal', function () {
    $('.error-msg').html('');
  });
});

function showModalPopUp(obj){
  $(".modal").modal("hide");
  $("#"+obj).modal('show');
};

function register(){
  $('.error-msg').html('');
  showModalPopUp('signup_modal');
}

function login(){
  $('.error-msg').html('');
  showModalPopUp('login_modal');
}