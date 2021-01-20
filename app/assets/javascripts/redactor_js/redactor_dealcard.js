(function($R) {
    $R.add('plugin', 'dealcard', {
        // modal code
        modals: {
            'dealcard': '<form action="" id="dealCardForm" name="dealCardForm">' +
                '<div class="form-item">' +
                '<label>Permalink</label>' +
                '<input required type="text" name="permalink_label" id="permalink_label">' +
                '<span class="input-error"> </span>' +
                '</div>' +
                '<div class="form-item">' +
                '<label for="hotness"><input type="checkbox" id="hotness" name="hotness"> Hotness </label>'+
                '</div>'+
                '</form>'
        },
        translations: {
            en: {
                // plugin title
                "dealcard": "ADD DEAL CARD"
            }
        },
        init: function(app) {
            // define app
            this.app = app;

            // define services
            this.lang = app.lang;
            this.toolbar = app.toolbar;
            this.insertion = app.insertion;
            this.marker = app.marker;
            this.selection = app.selection;
            this.editor = app.editor;
            this.caret = app.caret;
        },

        // messages
        onmodal: {
            // on modal open 
            dealcard: {
                opened: function($modal, $form) {
                    $form.getField('permalink_label').focus();
                },
                // getting form data on insert
                insert: function($modal, $form) {
                  var dealCardForm = document.forms['dealCardForm'];
                  var permaInp = dealCardForm.querySelector('.form-item #permalink_label');
                  var hotnessInp = dealCardForm.querySelector('.form-item #hotness');
                  var permaVal = permaInp.value;
                  var hotnessVal = hotnessInp.checked;
                  var that = this;
                  // run only if the permalink is not empty
                  if(permaVal != ""){
                      // clearing the error span
                      permaInp.nextElementSibling.innerText = '';
                      // storing form data in a variable
                      // ajax for getting topic
                      $.ajax({
                            url: ('/topic_widget_info'),
                            dataType: "JSON",
                            type: "get",
                            async:false,
                            data: {'permalink': permaVal},
                            success: function(response) {
                              if(response.hasOwnProperty("deal")){
                                var dealDetail = response.deal;
                                var formData = $form.getData();
                                // calling _inset function with formdata
                                that._insert(formData, dealDetail, hotnessVal);  
                              }else if(response.hasOwnProperty("error")){
                                permaInp.nextElementSibling.innerText = response.error;
                                return
                              }else{
                                return
                              }
                            }
                        });
                  }else{
                    // showing the error msg in the error span
                    permaInp.nextElementSibling.innerText = 'Permalink cant be Empty';
                    return;
                  }    
                }
            }
        },
        // public
        start: function() {
            var $editor = this.editor.getElement();
            $editor.on('keyup.redactor-plugin-handle', this._handle.bind(this));

            // disabling all the deal wrapper
            $('.redactor-deal-wrapper').each(function(index, item){
              $(this).attr({'contentEditable': false, 'unselectable': true});
            });

            // create the button data
            var buttonData = {
                title: this.lang.get('dealcard'),
                api: 'plugin.dealcard.open'
            };
            // create the button
            var $button = this.toolbar.addButton('dealcard', buttonData);
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
              if($(blockEl).hasClass('redactor-getdeal-wrapper')){
              // removing the parent is the parent is redactor-deal-wrapper
              var parentEl = $(blockEl).parents('.redactor-deal-wrapper')
              if(parentEl){ 
                parentEl.remove(); 
              }else{
                return
              }
            }
          }
        },
        open: function() {
            // modal options
            var options = {
                title: 'DEAL CARD',
                width: '600px',
                name: 'dealcard',
                handle: 'insert',
                commands: {
                    insert: { title: this.lang.get('insert') },
                    cancel: { title: this.lang.get('cancel') }
                }
            };
            // building modal
            this.app.api('module.modal.build', options);
        },
        extractContent: function(s) {
          var div = document.createElement('div');
          div.innerHTML = s;
          return div.textContent || div.innerText;
        },
        truncate: function(str, n){
          return (str.length > n) ? str.substr(0, n-1) + '&hellip;' : str;
        },
        domainName: function(){
          return window.location.origin;
        },
        // private
        _insert: function(data, deal, hotnessVal) {
            // closing modal on insert
            this.app.api('module.modal.close');
            // options available (start, end, before and after) for node insertion
            var marker = this.marker.insert('start');
            var $marker = $R.dom(marker);
            // output
            var dealImg = deal.image_medium;
            var dealPermalink = deal.permalink;
            var dealTitle = deal.title;
            var dealStore = deal.store;
            var dealStoreName = '<p class="redactor-store-name">Others</p>';
            if(!(dealStore == null)){
              dealStoreName = '<p class="redactor-store-name"><a href="'+this.domainName()+'/stores/'+dealStore.name+'">'+dealStore.name+'</a></p>';
            }
            var dealAuthor = deal.user.login;
            var dealAuthorImg = deal.user.image_medium;
            var dealtime = new Date(deal.created_at);
            var dealPostTime =  dealtime.getFullYear() + '-' + (dealtime.getMonth()+1) + '-' + dealtime.getDate();
            var dealUserId = deal.user.id;
            var dealDescString = this.extractContent(deal.description);
            var dealDesc = this.truncate(dealDescString, 150);
            var commentCount = deal.comments_count;
            var forumType = deal.forum.forum_type;
            if(forumType == 'deal'){
              var forumTypeLink = 'deals';
            }else if(forumType == 'discussion'){
              var forumTypeLink = 'discussions';
            }
            if(hotnessVal){ var hotness = '<img class="hotness" alt="Hotness" src="https://cdn1.desidime.com/ddb/hotness.png" style="height:30px;width:auto;">';}
            else{ var hotness = "" }
            var dealWrapper = '<div class="redactor-deal-wrapper parent-wrap" contentEditable="false" unselectable="true">'+
                              '<div class="redactor-deal-content-wrap">'+
                              '<div class="redactor-deal-img">' + hotness +
                              '<a href="'+this.domainName()+'/'+forumTypeLink+'/'+dealPermalink+'"><img src="'+dealImg+'"></a>'+
                              '</div>'+
                              '<div class="redactor-deal-content">'+
                              '<p class="redactor-deal-title"> <a target="_blank" href="'+this.domainName()+'/'+forumTypeLink+'/'+dealPermalink+'">'+dealTitle+'</a></p>' + dealStoreName +
                              '<div class="redactor-deal-desc">' +dealDesc+ '</div>'+
                              '<div class="redactor-deal-user">'+
                              '<div class="redactor-user-detail">'+
                              '<a class="redactor-deal-user-img" target="_blank" href="'+this.domainName()+'/users/'+dealUserId+'"><img src="'+dealAuthorImg+'"></a>'+
                              '<div class="redactor-deal-author">'+
                              '<a target="_blank" href="'+this.domainName()+'/users/'+dealUserId+'">'+dealAuthor+'</a>'+
                              '<p>'+dealPostTime+'</p>'+
                              '</div>'+
                              '</div>'+
                              '<div class="redactor-getdeal-wrapper">'+
                              '<a class="redactor-deal-comment" target="_blank" href="'+this.domainName()+'/'+forumTypeLink+'/'+dealPermalink+'"> <i class="ico ico-post"> </i> '+commentCount+'</a>'+
                              '<a class="redactor-getdeal-btn" target="_blank" href="'+this.domainName()+'/'+forumTypeLink+'/'+dealPermalink+'">Get Deal</a>'+
                              '</div>'+
                              '</div>'+
                              '</div>'+
                              '</div>'+
                              '</div>';
            $marker.before(dealWrapper);
            this.selection.restoreMarkers();
            this.insertion.insertBreakLine();
            return;
        }
    });
})(Redactor);