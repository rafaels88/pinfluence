var map, currentMapSources = {}, oldMapSources = {};

var marker;
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
    content: _createInfoWindowContent(influencer)
  });

  marker = new google.maps.Marker({
    position: myLatlng,
    animation: google.maps.Animation.DROP,
    map: map,
    title: influencer.name,
    icon: '/assets/marker-' + influencer.gender + '-' + influencer.level +'.png'
  });

  marker.addListener('click', function() {
    infowindow.open(map, marker);
  });
  infowindow.open(map, marker);
  return marker;
}

function _createInfoWindowContent(influencer) {
  return "<a target='_blank' href='https://en.wikipedia.org/wiki/" +influencer.name+ "'>" +
            "<img class='wikipedia icon' src='/assets/wikipedia.png'></a> " +
            influencer.name;
}

function renderInfluencersInMap(influencers){
  oldMapSources = currentMapSources;
  currentMapSources = {};

  $(influencers).each(function(i, influencer){

    if(oldMapSources[influencer.location_id] == undefined){
      influencer.shouldRender = true;
    } else {
      // Retrieves marker for this influencer
      influencer.marker = oldMapSources[influencer.location_id].marker;
    }

    currentMapSources[influencer.location_id] = influencer;
    delete oldMapSources[influencer.location_id];
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
