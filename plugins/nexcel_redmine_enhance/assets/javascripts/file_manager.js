$(document).ready(function(){
    $.ajax({
        url: "/projects/rd-casino-integration-improvement/dmsf.json",
        success: function(data){
            alert(data);
        }
    })
});