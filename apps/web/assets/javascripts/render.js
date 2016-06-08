$().ready(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoicmFmYWVsczg4IiwiYSI6ImJpWUZvaHcifQ.Bkjj9moCS4ILf_7tYlBKyg';
  var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v8'
  });

  var mapFeatures = [];
  $($("#map-container").data("coordinates")).each(function(i, coords){
    var feature = {
        "type": "Feature",
        "properties": {},
        "geometry": {
            "type": "Point",
            "coordinates": coords
        }
    }
    mapFeatures.push(feature);
  });

  map.on('load', function () {

      // add geojson data as a new source
      map.addSource("symbols", {
          "type": "geojson",
          "data": {
              "type": "FeatureCollection",
              "features": mapFeatures
          }
      });

      // add source as a layer and apply some styles
      map.addLayer({
          "id": "symbols",
          "type": "symbol",
          "source": "symbols",
          "layout": {
              "icon-image": "marker-15"
          },
          "paint": {}
      });
  });

  map.on('click', function (e) {
      // Use queryRenderedFeatures to get features at a click event's point
      // Use layer option to avoid getting results from other layers
      var features = map.queryRenderedFeatures(e.point, { layers: ['symbols'] });
      // if there are features within the given radius of the click event,
      // fly to the location of the click event
      if (features.length) {
          // Get coordinates from the symbol and center the map on those coordinates
          map.flyTo({center: features[0].geometry.coordinates});
      }
  });

  // Use the same approach as above to indicate that the symbols are clickable
  // by changing the cursor style to 'pointer'.
  map.on('mousemove', function (e) {
      var features = map.queryRenderedFeatures(e.point, { layers: ['symbols'] });
      map.getCanvas().style.cursor = features.length ? 'pointer' : '';
  });
});

