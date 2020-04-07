var e = document.getElementById("userID");
var userID = e.textContent || e.innerText;
Dropzone.autoDiscover = false;
$(document).ready(function () {
    $("#image-photo").dropzone({
        paramName: "group[image]", // The name that will be used to transfer the file
        url: '/users/' + userID + '/groups/upload',
        headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        },
        maxFiles: 1,
        maxfilesexceeded: function(file) {
            this.removeAllFiles();
            this.addFile(file);
        },
        init: function() {
            var submitButton = document.querySelector(".submit")
            myDropzone = this; // closure
        } });});