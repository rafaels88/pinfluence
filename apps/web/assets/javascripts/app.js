$().ready(function(){
  function init(){
    renderMap();

    requestYears(function(years){
      renderSlider(years, {
        onUpdate: function(currentYear){
          requestInfluencers(currentYear, function(influencers){
            renderInfluencersInMap(influencers);
          });
        }
      });
    });
  }

  init();
});

