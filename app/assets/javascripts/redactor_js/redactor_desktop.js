/* Editor Code */
// declaring editor

$R('.redactor-textarea', {
    imageFigure: false,
    plugins: ['table', 'alignment', 'nofollow', 'widget'],
    buttons: ["format","bold","italic", "deleted", "underline","lists","link","file","image","horizontalrule"],
    // handle: "/users.json",
    imageUpload: '/image_upload',
    minHeight: '100px',
    // handleStart: '1'
});

$R('.redactor-comment', {
    imageFigure: false,
    plugins: ['alignment'],
    buttons: ["format","bold","italic", "deleted", "underline","lists","link","file","image","horizontalrule"],
    // handle: "/users.json",
    minHeight: '200px',
    // handleStart: '1'
});