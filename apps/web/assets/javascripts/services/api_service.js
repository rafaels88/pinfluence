var apiUrl = $("#map-container").data("api-endpoint"), requestTimeout;

function requestYears(cb){
  $.ajax({
    url: apiUrl,
    success: function(response){
      cb(response.available_years);
    }
  });
}

function requestInfluencers(year, cb){
  clearTimeout(requestTimeout);

  requestTimeout = setTimeout(function(){
    var currentApiUrl = apiUrl;
    if(year){ currentApiUrl += "?year=" + year; }

    $.ajax({
      url: currentApiUrl,
      success: function(response){
        cb(response.collection);
      }
    });
  }, 300);
}
