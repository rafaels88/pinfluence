var apiUrl = $("#map-container").data("api-endpoint"),
    graph = graphql(apiUrl, {
      method: "POST",
      headers: {},
      fragments: {
        error: "on Error { messages }"
      }
    });

function performRequest(query, cb){
  graph.query(`query { `+query+` }`)()
    .then(function(response){
      cb(response)
    });
}

function requestYears(cb){
  performRequest('available_years { year, formatted }', function(response){
    return cb(response.available_years);
  })
}

function requestMoments(year, cb){
  performRequest(`moments(year: `+year+`) { influencer { id name type gender earliest_year } locations { latlng } year_begin }`, function(response){
    return cb(response.moments);
  })
}

function requestInfluencers(term, cb){
  performRequest(`influencers(name: "`+term+`") { people { id name gender type earliest_year  } events { id name type earliest_year } }`, function(response){
    return cb(response.influencers);
  })
}
