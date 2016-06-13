var map, currentMapSources = {}, oldMapSources = {};

function renderMap(){
  var myLatlng = new google.maps.LatLng(0, 0) ;
  var mapOptions = {
    zoom: 3,
    center: myLatlng,
  };
  map = new google.maps.Map(document.getElementById("map"), mapOptions);
}

function _createMarker(influencer) {
  var myLatlng = new google.maps.LatLng(influencer.latlng[0], influencer.latlng[1]);
  var infowindow = new google.maps.InfoWindow({
    content: influencer.name
  });

  var marker = new google.maps.Marker({
    position: myLatlng,
    animation: google.maps.Animation.DROP,
    map: map,
    title: influencer.name
  });
  marker.addListener('click', function() {
    infowindow.open(map, marker);
  });
  infowindow.open(map, marker);
  return marker;
}

function renderInfluencersInMap(influencers){
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
      influencer.marker = _createMarker(influencer);
      currentMapSources[influencerId] = influencer;
    }
  });

  // Remove Markers
  $.each(oldMapSources, function(influencerId, influencer){
    influencer.marker.setMap(null);
  });
}
