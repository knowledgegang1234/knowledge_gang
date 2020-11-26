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