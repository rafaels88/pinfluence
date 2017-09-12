var map, currentMapSources = {}, oldMapSources = {};

function renderMap(){
  map = new google.maps.Map(document.getElementById("map"),
                            { zoom: 3, center: new google.maps.LatLng(0, 0) });
}

function renderInfluencesInMap(influences){
  var influencers = [];

  $(influences).each(function(i, inf){ influencers.push(inf) });

  _renderInfluencers(influencers);
}

function _renderInfluencers(influencers){
  oldMapSources = currentMapSources;
  currentMapSources = {};

  $(influencers).each(function(i, influencer){

    if(oldMapSources[influencer.id] == undefined){
      influencer.marker = _createMarker(influencer);
    } else {
      influencer.marker = oldMapSources[influencer.id].marker;
      _moveMarker(influencer.marker, influencer.locations[0]);
    }

    influencer.marker.infowindow.setContent(_createInfoWindowContent(influencer));

    currentMapSources[influencer.id] = influencer;
    delete oldMapSources[influencer.id];
  });

  // Remove Markers
  $.each(oldMapSources, function(id, influencer){ influencer.marker.setMap(null) });
}

function _moveMarker(marker, newLocation){
  var newLatLng = new google.maps.LatLng(newLocation.latlng[0],
                                         newLocation.latlng[1]);
  marker.setPosition(newLatLng)
}

function _createMarker(influencer) {
  var influencerLocation = influencer.locations[0];
  var myLatlng = new google.maps.LatLng(influencerLocation.latlng[0],
                                        influencerLocation.latlng[1]);
  var infowindow = new google.maps.InfoWindow();

  var marker = new SlidingMarker({
    position: myLatlng,
    animation: google.maps.Animation.DROP,
    map: map,
    title: influencer.name,
    icon: '/assets/pin-' + influencer.gender + '2.png'
  });

  marker.addListener('click', function() { infowindow.open(map, marker) });
  infowindow.open(map, marker);

  marker.infowindow = infowindow;
  return marker;
}

function _createInfoWindowContent(influencer) {
  return influencer.name + " (" + influencer.age + "y)";
}
