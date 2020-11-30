$('#like-side-blog').click(function() {
  var blog_id = $('#like-side-blog').data('blog-slug');
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
})
