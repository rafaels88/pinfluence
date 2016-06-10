$().ready(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoicmFmYWVsczg4IiwiYSI6ImJpWUZvaHcifQ.Bkjj9moCS4ILf_7tYlBKyg';
  var apiUrl = $("#map-container").data("api-endpoint"), map, currentMapSources = {}, oldMapSources = {}, requestTimeout;

  function init(){
    requestYears(function(years){
      renderSlider(years);
    })
  }

  function requestYears(cb){
    $.ajax({
      url: apiUrl,
      success: function(response){
        cb(response.available_years);
      }
    });
  }

  function requestInfluencers(year){
    clearTimeout(requestTimeout);

    requestTimeout = setTimeout(function(){
      var currentApiUrl = apiUrl;
      if(year){ currentApiUrl += "?year=" + year; }

      $.ajax({
        url: currentApiUrl,
        success: function(response){
          var mapInfluencers = $.map(response.collection, function(influencer){
            console.log(influencer.latlng)
            return {
              influencerId: influencer.id,
              mapFeature: {
                "type": "Feature",
                "properties": {},
                "geometry": {
                  "type": "Point",
                  "coordinates": [influencer.latlng[1], influencer.latlng[0]]
                }
              }
            }
          });

          renderMap(mapInfluencers);
        }
      });
    }, 500);
  }

  function renderSlider(range){
    var bigValueSlider = document.getElementById('slider-huge'),
        bigValueSpan = document.getElementById('huge-value');

    noUiSlider.create(bigValueSlider, {
      start: 0,
      step: 1,
      format: wNumb({
        decimals: 0
      }),
      range: {
        min: 0,
        max: range.length-1
      }
    });

    bigValueSlider.noUiSlider.on('update', function ( values, handle ) {
      var currentValue = range[values[handle]]
      bigValueSpan.innerHTML = currentValue;
      requestInfluencers(currentValue);
    });
  }

  function renderMap(mapInfluencers){
    oldMapSources = currentMapSources;
    currentMapSources = {};

    $(mapInfluencers).each(function(i, influencer){
      if(oldMapSources[influencer.influencerId] == undefined){
        influencer.shouldRender = true;
      }
      currentMapSources[influencer.influencerId] = influencer;
      delete oldMapSources[influencer.influencerId];
    });

    $.each(currentMapSources, function(influencerId, influencer){
      if(influencer.shouldRender == true){
        var sourceId = "i-" + influencerId;

        map.addSource(sourceId, {
            "type": "geojson",
            "data": {
              "type": "FeatureCollection",
              "features": [influencer.mapFeature]
            }
        });

        map.addLayer({
            "id": sourceId,
            "type": "symbol",
            "source": sourceId,
            "layout": {
              "icon-image": "marker-15"
            },
            "paint": {}
        });
      }
    });

    $.each(oldMapSources, function(influencerId, influencer){
      map.removeLayer("i-" + influencerId);
      map.removeSource("i-" + influencerId);
    });
  }

  map = new mapboxgl.Map({ container: 'map', style: 'mapbox://styles/mapbox/streets-v8' });
  map.on('load', init);
});

