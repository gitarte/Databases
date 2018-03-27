/*global $ */
$(document).ready(function(){
    $('#submit').click(function(){
        $.post("http://devel:8080/login",{
            'user' : $("#username").val(),
            'pass' : $("#password").val()
        },function(data){
            if(data.error) {
                alert(data.message);
            } else {
                window.location.href = "/home";
            }
        });
    });
});
