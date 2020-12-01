/* Editor Code */
// declaring editor

$R('.redactor-textarea', {
    imageFigure: false,
    plugins: ['table', 'alignment', 'addbutton', 'nofollow'],
    // handle: "/users.json",
    imageUpload: '/upload/images',
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