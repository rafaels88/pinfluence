var apiGraphqlUrl = $("#map-container").data("api_graphql-endpoint"),
    graph = graphql(apiGraphqlUrl, {
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
  graph.query(`query { moments(year: `+year+`) { influencer { id name gender } locations { latlng } year_begin } }`)()
    .then(function(response){
      cb(response.moments)
    });
}

function requestYearByInfluenceName(name, cb){
  graph.query(`query { moments(name: `+name+`) { influencer { id name gender } locations { latlng } year_begin } }`)()
    .then(function(response){
      cb(response.moments)
    });
}
