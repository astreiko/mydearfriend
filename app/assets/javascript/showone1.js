window.addEventListener('popstate',function(event){location.reload(true);});
var e = document.getElementById("itemid");
var itemid = e.textContent || e.innerText;
var max = 0;
var oldHash = window.location.pathname;
$(document).ready(function repeatRequest() {
    if (oldHash != window.location.pathname) return;
    else{
        var body, id;
        $.ajax({
                type: 'GET',
                dataType: 'json',
                url: "show",
                async: false,
                data: { id: itemid, max_id: max},
            success: function(data){
            $.each(data, function (key, text) {
                $.each(text, function (index, value) {
                    if (index === "id") {if (max < value) max = value;}
                    if (index === "body") {body = value;}
                    if (index === "created_at") {
                        original = value;
                        created_at = original.slice(0, 10) + " " + original.slice(11, 19)
                    }
                    if (index === "name") {$( ".comments").append("<div />", {'id': id}).append( "<table><tr><td><b><div>" + value + "</div></b><span>" + created_at + "</span></td></tr><tr><td>" + body + "</td></tr></table><br/>" );}});});}});
        setTimeout(repeatRequest, 5000);};})