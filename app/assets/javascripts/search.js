document.addEventListener("turbolinks:load", function() {
  $input = $("[data-behavior='autocomplete']");

  var options = {
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
        header: '<b style="color: #65CCB8;">Tags</b>'
      },
      {
        listLocation: 'categories',
        header: '<b style="color: #65CCB8;">Categories</b>'
      },
      {
        listLocation: 'users',
        header: '<b style="color: #65CCB8;">Users</b>'
      },
      {
        listLocation: 'articles',
        header: '<b style="color: #65CCB8;">Articles</b>'
      }
    ],
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url;
        $input.val('');
        Turbolinks.visit(url);
      }
    }
  }
  $input.easyAutocomplete(options);
});