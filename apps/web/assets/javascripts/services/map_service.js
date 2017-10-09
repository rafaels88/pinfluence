var map, currentMapSources = {}, oldMapSources = {};

function renderMap(){
  map = new google.maps.Map(document.getElementById("map"), { zoom: 3, center: new google.maps.LatLng(0, 0) });
}

function renderMomentsInMap(moments, currentDate){
  oldMapSources = currentMapSources;
  currentMapSources = {};

  $(moments).each(function(i, moment){
    if(moment.influencer.type === 'person') {
      if(oldMapSources[moment.influencer.id] == undefined){
        moment.marker = _createMarker(moment);
      } else {
        moment.marker = oldMapSources[moment.influencer.id].marker;
        _moveMarker(moment.marker, moment.locations[0]);
      }

      moment.marker.infowindow.setContent(_createInfoWindowContent(moment, currentDate));

      currentMapSources[moment.influencer.id] = moment;
      delete oldMapSources[moment.influencer.id];
    }
  });

  // Remove Markers
  $.each(oldMapSources, function(id, moment){ moment.marker.setMap(null) });
}

function _moveMarker(marker, newLocation){
  var newLatLng = new google.maps.LatLng(newLocation.latlng[0], newLocation.latlng[1]);
  marker.setPosition(newLatLng)
}

function _createMarker(moment) {
  var momentLocation = moment.locations[0],
      myLatlng = new google.maps.LatLng(momentLocation.latlng[0], momentLocation.latlng[1]),
      infowindow = new google.maps.InfoWindow();

  var marker = new SlidingMarker({
    position: myLatlng,
    animation: google.maps.Animation.DROP,
    map: map,
    title: moment.influencer.name,
    icon: '/assets/pin-' + moment.influencer.gender + '2.png'
  });

  marker.infowindow = infowindow;
  marker.addListener('click', function() { infowindow.open(map, marker) });
  infowindow.open(map, marker);

  return marker;
}

function _createInfoWindowContent(moment, currentDate) {
  var currentAge = _currentAgeForInfluencer(moment.influencer.earliest_date, currentDate);
  return moment.influencer.name + ' (' + currentAge + 'y)';
}

function _currentAgeForInfluencer(birthDate, currentDate) {
  return differenceInYearsBetween(new Date(currentDate), new Date(birthDate));
}
