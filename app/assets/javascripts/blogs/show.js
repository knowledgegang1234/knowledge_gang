//= require jquery3
//= require redactor_js/redactor.min
//= require redactor_js/alignment.min
//= require redactor_js/table.min
//= require redactor_js/nofollow
//= require redactor_js/handle.min
//= require redactor_js/redactor_button
//= require redactor_js/redactor_emoji
//= require redactor_js/redactor_desktop

$('.like-side-blog').click(function() {
  var blog_id = $('.like-side-blog').data('blog-slug');
  $.ajax({
    type: 'POST',
    url: '/blogs/'+blog_id+'/like',
    data: {},
    dataType: "script",
    success: function () {
    },
    error: function () {
    }
  });
});

$('.bookmark-side-blog').click(function() {
  var blog_id = $('.bookmark-side-blog').data('blog-slug');
  $.ajax({
    type: 'POST',
    url: '/blogs/'+blog_id+'/bookmark',
    data: {},
    dataType: "script",
    success: function () {
    },
    error: function () {
    }
  });
});