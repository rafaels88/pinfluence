$().ready(function(){
  function init(){
    var initialYear = new Date().getFullYear() - 100;
    renderMap();

    requestYears(function(years){
      renderSlider(years, {
        onChange: function(currentYear){
          requestMoments(currentYear, function(moments){
            renderMomentsInMap(moments, currentYear);
          });
        },
        onInit: function(){
          changeSliderTo(initialYear);
          requestMoments(initialYear, function(moments){
            renderMomentsInMap(moments, initialYear);
          });
        }
      });
    });

    listenSearch({
      onSearch: function(term){
        requestInfluencers(term, function(influencers){
          renderInfluencersSearchResult(influencers);
        });
      },
      onSelectedResult: function(year){
        requestMoments(year, function(moments){
          changeSliderTo(year);
          renderMomentsInMap(moments, year);
        });
      }
    });

    listenRequestYear({
      onSearch: function(year){
        changeSliderTo(year);

        requestMoments(year, function(moments){
          renderMomentsInMap(moments, year);
        });
      }
    });
  }
  init();
});
