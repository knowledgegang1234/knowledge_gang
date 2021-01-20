(function($R) {
  $R.add('plugin', 'ads', {
    translations: {
      en: {
        "ads": "INSERT AD",
      }
    },
    init: function(app) {
      this.app = app;
      this.opts = app.opts;
      this.lang = app.lang;
      this.$doc = app.$doc;
      this.$body = app.$body;
      this.editor = app.editor;
      this.marker = app.marker;
      this.keycodes = app.keycodes;
      this.container = app.container;
      this.selection = app.selection;
      this.toolbar = app.toolbar;
    },
    start: function() {
      var $editor = this.editor.getElement();
      $editor.on('keyup.redactor-plugin-handle', this._handle.bind(this));

      var obj = {
        title: this.lang.get('ads'),
        api: 'plugin.ads.insert_ads',
        observe: 'ads'
      };
      this.toolbar.addButton('ads', obj);
    },
    _handle: function(e){
      // on backspace deleting the whole deal wrapper
      if(e.which == 8 ) {
        e.preventDefault();
        // saving selection
        this.selection.save();
        // restoring selection
        this.selection.restore();
        // getting the active block
        var blockEl = this.selection.getBlock();
        if($(blockEl).hasClass('redactor-ads')){
          // removing the el
          blockEl.remove();
        }else{
          return
        }
      }
    },
    insert_ads: function() {
      var marker = this.marker.insert('start');
      var $marker = $R.dom(marker);
      var el = "<div class='redactor-ads tc' contentEditable='false' unselectable='true'> ||google_ad|| </div>"
      $marker.before(el);
      this.selection.restoreMarkers();
      this.insertion.insertBreakLine();
      return;
    }
  });
})(Redactor);