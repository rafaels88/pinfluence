var apiUrl = $("#map-container").data("api-endpoint"), requestTimeout;

function requestYears(cb){
  $.ajax({
    url: apiUrl,
    success: function(response){
      cb(response.available_years, response.available_years_formatted);
    }
  });
}

function requestInfluencers(year, cb){
  var currentApiUrl = apiUrl;
  if(year){ currentApiUrl += "?year=" + year; }

  $.ajax({
    url: currentApiUrl,
    success: function(response){
      cb(response.collection);
    }
  });
}

function requestYearByInfluencerName(name, cb){
  var currentApiUrl = apiUrl;
  if(name){ currentApiUrl += "?name=" + name; }

  $.ajax({
    url: currentApiUrl,
    success: function(response){
      cb(response.collection[0].begin_in);
    }
  });
}
