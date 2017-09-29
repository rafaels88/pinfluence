var apiUrl = $("#map-container").data("api-endpoint"),
    graph = graphql(apiUrl, {
      method: "POST",
      headers: {},
      fragments: {
        error: "on Error { messages }"
      }
    });

function requestYears(cb){
  graph.query(`query { available_years { year, formatted } }`)()
    .then(function(response){
      cb(response.available_years)
    });
}

function requestMoments(year, cb){
  graph.query(`query { moments(year: `+year+`) { influencer { id name type gender } locations { latlng } year_begin } }`)()
    .then(function(response){
      cb(response.moments)
    });
}

function requestInfluencers(term, cb){
  graph.query(`query { influencers(name: "`+term+`") { people { id name gender type earliest_year  } events { id name type earliest_year } } }`)()
    .then(function(response){
      return cb(response.influencers)
    });
}
