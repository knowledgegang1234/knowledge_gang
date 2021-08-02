$(document).ready(function() {
  $input = $("[data-behavior='autocomplete']");

  var options = {
    minCharNumber: 3,
    getValue: "name",
    url: function(phrase) {
      return "/search.json?q=" + phrase;
    },
    template: {
      type: "custom",
      method: function(value, item) {
        let prefix = "";
        if (item.type === 'tag') {
          prefix = "<i class='fas fa-tag mr-2'></i>"
        } else if (item.type === 'user') {
          prefix = "<img src='" + item.avatar + "' class='rounded-circle' width='30px' height='30px'>"
          return prefix + ' ' + value;
        }
        return prefix + value;
      }
    },
    categories: [
      {
        listLocation: 'tags',
        header: '<b>Tags</b>'
      },
      // {
      //   listLocation: 'categories',
      //   header: '<b>Categories</b>'
      // },
      {
        listLocation: 'users',
        header: '<b>Users</b>'
      },
      {
        listLocation: 'articles',
        header: '<b>Articles</b>'
      }
    ],
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url;
        $input.val('');
        window.location.href = url;
      }
    }
  }
  $input.easyAutocomplete(options);
});