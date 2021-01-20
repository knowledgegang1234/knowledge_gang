/* Editor Code */
// declaring editor

$R('.redactor-textarea', {
    imageFigure: false,
    plugins: ['table', 'alignment', 'addbutton', 'nofollow', 'widget'],
    buttons: ["html","format","bold","italic", "deleted", "underline","lists","link","file","image","horizontalrule"],
    // handle: "/users.json",
    imageUpload: '/image_upload',
    minHeight: '400px',
    // handleStart: '1'
});

$R('.redactor-comment', {
    imageFigure: false,
    plugins: ['alignment'],
    // handle: "/users.json",
    minHeight: '200px',
    // handleStart: '1'
});