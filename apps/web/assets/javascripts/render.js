$().ready(function(){
  var apiUrl = $("#map-container").data("api-endpoint"), map, currentMapSources = {}, oldMapSources = {}, requestTimeout;

  function init(){
    var myLatlng = new google.maps.LatLng(0, 0) ;
    var mapOptions = {
      zoom: 3,
      center: myLatlng,
    };
    map = new google.maps.Map(document.getElementById("map"),
        mapOptions);

    requestYears(function(years){
      renderSlider(years, {
        onUpdate: function(currentYear){
          requestInfluencers(currentYear, function(influencers){
            renderMap(influencers);
          });
        }
      });
    });
  }

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

  function renderSlider(range, callbacks){
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
      callbacks.onUpdate(currentValue);
    });
  }

  function renderMap(influencers){
    oldMapSources = currentMapSources;
    currentMapSources = {};

    $(influencers).each(function(i, influencer){
      if(oldMapSources[influencer.id] == undefined){
        influencer.shouldRender = true;
      } else {
        // Retrieves marker for this influencer
        influencer.marker = oldMapSources[influencer.id].marker;
      }

      currentMapSources[influencer.id] = influencer;
      delete oldMapSources[influencer.id];
    });

    // Add Markers
    $.each(currentMapSources, function(influencerId, influencer){
      if(influencer.shouldRender == true){
        var myLatlng = new google.maps.LatLng(influencer.latlng[0], influencer.latlng[1]);

        var marker = new google.maps.Marker({
            position: myLatlng,
            animation: google.maps.Animation.DROP,
            map: map,
            title: influencer.name
        });
        influencer.marker = marker;
        currentMapSources[influencerId] = influencer;
      }
    });

    // Remove Markers
    $.each(oldMapSources, function(influencerId, influencer){
      influencer.marker.setMap(null);
    });
  }

  init();
});

