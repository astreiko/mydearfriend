var e = document.getElementById("userID");
var userID = e.textContent || e.innerText;
Dropzone.autoDiscover = false;
jQuery(document).ready(function($){
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
        }
    });
});

i=0;
function add_field() {
    $("#add_field").prepend("<div id="+ i +"></br><input placeholder='Field name' name='titleAdd[]' required style='margin: 5px 0'>&nbsp;&nbsp;<select name='typeAdd[]' required><option option value=\"\">Type</option><option>String</option><option>Text</option><option>Boolean</option><option>Date</option><option>Float</option><select/>&nbsp;&nbsp;<input value=\" X \" type=\"button\"  onclick=\"\$('#"+i+"')\.remove()\;\" ><br/></div>");
    i = i + 1;
}
