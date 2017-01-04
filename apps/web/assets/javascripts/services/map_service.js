var map, currentMapSources = {}, oldMapSources = {};

function renderMap(){
  var mapOptions = {
    zoom: 3,
    center: new google.maps.LatLng(0, 0),
  };
  map = new google.maps.Map(document.getElementById("map"), mapOptions);
}

function renderInfluencesInMap(influences){
  var influencers = [], events = [];
  $(influences).each(function(i, influence){
    if(influence.kind == "event"){
      events.push(influence);
    } else if (influence.kind == "person"){
      influencers.push(influence);
    }
  });

  _renderInfluencers(influencers);
  _renderEvents(events);
}

function _renderInfluencers(influencers){
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

  $.each(currentMapSources, function(influencerId, influencer){
    // Add new Markers
    if(influencer.shouldRender == true){
      influencer.marker = _createMarker(influencer);
      currentMapSources[influencerId] = influencer;
    } else {
      // Update existent marker
      influencer.marker.infowindow.setContent(_createInfoWindowContent(influencer));
    }
  });

  // Remove Markers
  $.each(oldMapSources, function(influencerId, influencer){
    influencer.marker.setMap(null);
  });
}

function _renderEvents(mapEvents){
  var locations = [];
  $(mapEvents).each(function(i, mapEvent){
    var location = new google.maps.LatLng(mapEvent.latlng[0], mapEvent.latlng[1]);
    locations.push({
      location: location, weight: mapEvent.density
    });
  });
  _createHeatmap(locations);
}

function _createHeatmap(locations) {
  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: locations,
    map: map
  });
  heatmap.set('radius', 20);
}

function _createMarker(influencer) {
  var influencerLocation = influencer.locations[0];
  var myLatlng = new google.maps.LatLng(influencerLocation.latlng[0],
                                        influencerLocation.latlng[1]);
  var infowindow = new google.maps.InfoWindow({
    content: _createInfoWindowContent(influencer)
  });

  var marker = new google.maps.Marker({
    position: myLatlng,
    animation: google.maps.Animation.DROP,
    map: map,
    title: influencer.name,
    icon: '/assets/pin-' + influencer.gender + '2.png'
  });

  marker.addListener('click', function() {
    infowindow.open(map, marker);
  });
  infowindow.open(map, marker);

  marker.infowindow = infowindow;
  return marker;
}

function _createInfoWindowContent(influencer) {
  return influencer.name + " (" + influencer.age + "y)";
}
