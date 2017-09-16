$().ready(function(){
  function init(){
    var initialYear = new Date().getFullYear() - 100;
    renderMap();

    requestYears(function(years){
      renderSlider(years, {
        onChange: function(currentYear){
          requestMoments(currentYear, function(moments){
            renderMomentsInMap(moments);
          });
        },
        onInit: function(){
          changeSliderTo(initialYear);
          requestMoments(initialYear, function(moments){
            renderMomentsInMap(moments);
          });
        }
      });
    });

    listenSearch({
      onSearch: function(term){
        requestYearByInfluenceName(term, function(moments){
          changeSliderTo(moments[0].year_begin);
          renderMomentsInMap(moments);
        })
      }
    });

    listenRequestYear({
      onSearch: function(year){
        changeSliderTo(year);

        requestMoments(year, function(moments){
          renderMomentsInMap(moments);
        });
      }
    });
  }
  init();
});
