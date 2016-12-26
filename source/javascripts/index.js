var $ = require('jquery');

function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam)
        {
            return sParameterName[1];
        }
    }
}

$(document).ready(function() {
    var total_interviews;

    $.getJSON('https://survey.alphaobservatory.org/en/total_interviews', function(data) {
        total_interviews = data.total;
        $(".js-total_interviews").html(total_interviews);
    });
});
