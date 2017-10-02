$().ready(function(){
  var initialYear = new Date().getFullYear() - 100;

  function resetSearch(){
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
  }

  function init(){
    renderMap();

    resetSearch();

    listenSearch({
      onSearch: function(term){
        requestInfluencers(term, function(influencers){
          renderInfluencersSearchResult(influencers);
        });
      },
      onSelectedResult: function(ctx){
        requestYearsForInfluencer(ctx.influencer, function(years){
          renderSlider(years, {
            onChange: function(currentYear){
              requestMoments(currentYear, function(moments){
                renderMomentsInMap(moments, currentYear);
              });
            },
            onInit: function(){
              requestMoments(ctx.year, function(moments){
                changeSliderTo(ctx.year);
                renderMomentsInMap(moments, ctx.year);
              });
            }
          });
        });
      },
      onResetSearch: resetSearch
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
