var e = document.getElementById("itemid");
var itemid = e.textContent || e.innerText;
var a = document.getElementById("currentuserid");
var currentuserid = a.textContent || a.innerText;
function likes() {
    var vote = 0;
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: "likes",
        data: {user_id: currentuserid, item_id: itemid},
    success: function(data){
        $.each(data, function (index, value) {
            if (index === "id")
                vote = 1;});
        if (vote == 1) document.getElementById('image').setAttribute("src", "/assets/red_heart.png");
        if (vote == 0) document.getElementById('image').setAttribute("src", "/assets/white_heart.png");}});}

$(document).ready(function loadingLikes() {
    var vote = 0;
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: "loadingLikes",
        data: {user_id: currentuserid, item_id: itemid},
    success: function(data){
        $.each(data, function (index, value) {
            if (index === "id") {
                vote = 1;
                document.getElementById('image').setAttribute("src", "/assets/red_heart.png");}});
        if (vote != 1) document.getElementById('image').setAttribute("src", "/assets/white_heart.png");}});})