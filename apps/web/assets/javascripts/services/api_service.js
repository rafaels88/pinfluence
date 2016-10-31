var apiUrl = $("#map-container").data("api-endpoint"),
  apiYearsUrl = $("#map-container").data("api-years-endpoint"),
  requestTimeout;

function requestYears(cb){
  $.ajax({
    url: apiYearsUrl,
    success: function(response){
      cb(response.available_years, response.available_years_formatted);
    }
  });
}

function requestInfluences(year, cb){
  var currentApiUrl = apiUrl;
  if(year){ currentApiUrl += "?year=" + year; }

  $.ajax({
    url: currentApiUrl,
    success: function(response){
      cb(response.collection);
    }
  });
}

function requestYearByInfluenceName(name, cb){
  var currentApiUrl = apiUrl;
  if(name){ currentApiUrl += "?name=" + name; }

  $.ajax({
    url: currentApiUrl,
    success: function(response){
      cb(response.collection[0].begin_in);
    }
  });
}
