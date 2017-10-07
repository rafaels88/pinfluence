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

function requestDates(cb){
  performRequest('available_dates { date, formatted }', function(response){
    return cb(response.available_dates);
  })
}

function requestDatesForInfluencer(influencer, cb){
  performRequest(`available_dates(influencer_id: `+ influencer.id +`, influencer_type: "`+ influencer.type +`") { date, formatted }`, function(response){
    return cb(response.available_dates);
  })
}

function requestMoments(date, cb){
  performRequest(`moments(date: "`+date+`") { influencer { id name type gender earliest_date } locations { latlng } date_begin }`, function(response){
    return cb(response.moments);
  })
}

function requestInfluencers(term, cb){
  performRequest(`influencers(name: "`+term+`") { people { id name gender type earliest_date  } events { id name type earliest_date } }`, function(response){
    return cb(response.influencers);
  })
}
