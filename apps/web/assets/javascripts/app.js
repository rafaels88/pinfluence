$().ready(function(){
  function init(){
    renderMap();

    requestYears(function(years, formattedYears){
      renderSlider(years, formattedYears, {
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

    listenSearch({
      onSearch: function(term){
        requestYearByInfluencerName(term, function(year){
          changeSliderTo(year);

          requestInfluencers(year, function(influencers){
            renderInfluencersInMap(influencers);
          });
        })
      }
    })
  }
  init();
});

