(function($R) {
    // plugin name is addbutton which can be integrated as a plugin in the redactor editor's instance.
    $R.add('plugin', 'addbutton', {
        // modal code
        modals: {
            'addbutton': '<form action="" id="addButtonForm" name="addButtonForm">' +
                '<div class="form-item">' +
                '<label>## buttonLabel ##</label>' +
                '<input required type="text" name="cst_btn_label" id="label">' +
                '<span class="input-error"> </span>' +
                '</div>' +
                '<div class="form-item">' +
                '<label>## linkLabel ##</label>' +
                '<input required type="url" name="cst_btn_link" id="link">' +
                '<span class="input-error"> </span>' +
                '</div>' +
                '<div class="form-item">' +
                '<label>## colorLabel ##</label>' +
                '<select required class="custom-select" name="cst_btn_color" id="cst_btn_color">' +
                '  <option value="btn_## colorOne ##" selected> ## colorOne ## </option>' +
                '  <option value="btn_## colorTwo ##"> ## colorTwo ## </option>' +
                '  <option value="btn_## colorThree ##"> ## colorThree ## </option>' +
                '</select>' +
                '</div>' +
                '</form>'
        },
        translations: {
            en: {
                // plugin title
                "addbutton": "ADD BUTTON",
                // input labels
                "addbutton-label": "Please, type some text",
                "buttonLabel": "Please Add label",
                "linkLabel": "Please Add Link",
                "colorLabel": "Please Select Color",
                "colorOne": "blue",
                "colorTwo": "green",
                "colorThree": "orange"
            }
        },
        init: function(app) {
            // define app
            this.app = app;

            // define services
            this.lang = app.lang;
            this.toolbar = app.toolbar;
            this.insertion = app.insertion;
        },

        // messages
        onmodal: {
            // on modal open 
            addbutton: {
                opened: function($modal, $form) {
                    $form.getField('cst_btn_label').focus();
                },
                // getting form data on insert
                insert: function($modal, $form) {
                    var addButtonForm = document.forms['addButtonForm'];
                    var labelInp = addButtonForm.querySelector('.form-item #label');
                    var linkInp = addButtonForm.querySelector('.form-item #link');
                    var valid = false;
                    for (var i = 0; i < addButtonForm.length; i++) {
                        var formText = addButtonForm[i].id;
                        var formItem = document.querySelectorAll('#addButtonForm .form-item')[i];
                        var span = formItem.querySelector('span.input-error');
                        if (addButtonForm[i].value != "") {
                            if (span) {
                                span.innerText = "";
                            }
                        }
                         else {
                            span.innerText = formText + ' cannot be blank ';
                        }
                    }
                    var linkInp = document.querySelectorAll('.form-item #link');
                    if(linkInp.value != ""){
                        var urlString = linkInp[0].value;
                        var urlRegex = /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/gi;
                        var result = urlString.match(urlRegex);
                        if(result !== null){
                            valid = true;
                        }
                        else{
                            linkInp[0].parentElement.querySelector('.input-error').innerText = 'Please Enter a valid URL';
                            valid = false;
                        }
                    }

                    if (labelInp.value != "" && linkInp.value != "" && valid) {
                        // storing form data in a variable
                        var formData = $form.getData();
                        // calling _inset function with formdata
                        this._insert(formData);
                    }
                }
            }
        },

        // public
        start: function() {
            // create the button data
            var buttonData = {
                title: this.lang.get('addbutton'),
                api: 'plugin.addbutton.open'
            };
            // create the button
            var $button = this.toolbar.addButton('addbutton', buttonData);
        },
        open: function() {
            // modal options
            var options = {
                title: this.lang.get('addbutton'),
                width: '600px',
                name: 'addbutton',
                handle: 'insert',
                commands: {
                    insert: { title: this.lang.get('insert') },
                    cancel: { title: this.lang.get('cancel') }
                }
            };
            // building modal
            this.app.api('module.modal.build', options);
        },

        // private
        _insert: function(data) {
            // closing modal on insert
            this.app.api('module.modal.close');
            // getting all the values from the input fields of the form
            var button_label = data.cst_btn_label;
            var button_link = data.cst_btn_link;
            var button_color = data.cst_btn_color;

            /* for adding custom button as a text in the editor */

            // creating a required valute variable with the form data variables.
            // var reqVal = '-----button-start{button: {colour: '+ button_color +' , url: '+ button_link +', text: '+ button_label +'} }-----button-end';
            var anchor = document.createElement('a');
            anchor.classList.add(button_color);
            anchor.innerText = button_label;
            anchor.href = button_link;
            anchor.setAttribute('target', '_blank');
            anchor.setAttribute('rel', 'nofollow');
            var output = document.createElement('div');
            var br = document.createElement('br');
            output.classList.add('editor-btn');
            // adding the required value in the output
            output.append(anchor);
            // inserting this in the page
            // options available (start, end, before and after) for node insertion
            this.insertion.insertNode(output, 'end');
            this.insertion.insertBreakLine();
        }
    });
})(Redactor);