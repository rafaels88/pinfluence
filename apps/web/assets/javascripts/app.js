$().ready(function(){
  var initialDate = new Date();
  initialDate.setDate(1);
  initialDate.setMonth(0);

  var initialDateStr = changeDateYear(initialDate, -100);

  function resetSearch(){
    requestDates(function(dates){
      renderSlider(dates, {
        onChange: function(currentDate){
          requestMoments(currentDate, function(moments){
            renderMomentsInMap(moments, currentDate);
          });
        },
        onInit: function(){
          changeSliderTo(initialDateStr);
          requestMoments(initialDateStr, function(moments){
            renderMomentsInMap(moments, initialDateStr);
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
        requestDatesForInfluencer(ctx.influencer, function(dates){
          renderSlider(dates, {
            onChange: function(currentDate){
              requestMoments(currentDate, function(moments){
                renderMomentsInMap(moments, currentDate);
              });
            },
            onInit: function(){
              requestMoments(ctx.date, function(moments){
                changeSliderTo(ctx.date);
                renderMomentsInMap(moments, ctx.date);
              });
            }
          });
        });
      },
      onResetSearch: resetSearch
    });

    listenRequestDate({
      onSearch: function(date){
        changeSliderTo(date);

        requestMoments(date, function(moments){
          renderMomentsInMap(moments, date);
        });
      }
    });
  }

  init();
});
