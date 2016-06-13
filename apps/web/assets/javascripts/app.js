$().ready(function(){
  function init(){
    renderMap();

    requestYears(function(years){
      renderSlider(years, {
        onChange: function(currentYear){
          requestInfluencers(currentYear, function(influencers){
            renderInfluencersInMap(influencers);
          });
        },
        onInit: function(){
          requestInfluencers(years[0], function(influencers){
            renderInfluencersInMap(influencers);
          });
        }
      });
    });
  }

  init();
});

