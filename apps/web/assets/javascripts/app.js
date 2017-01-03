$().ready(function(){
  function init(){
    renderMap();

    requestYears(function(years, formattedYears){
      renderSlider(years, formattedYears, {
        onChange: function(currentYear){
          requestInfluences(currentYear, function(influences){
            renderInfluencesInMap(influences);
          });
        },
        onInit: function(){
          requestInfluences(years[0], function(influences){
            renderInfluencesInMap(influences);
          });
        }
      });
    });

    listenSearch({
      onSearch: function(term){
        requestYearByInfluenceName(term, function(year){
          changeSliderTo(year);

          requestInfluences(year, function(influences){
            renderInfluencesInMap(influences);
          });
        })
      }
    });

    listenRequestYear({
      onSearch: function(year){
        changeSliderTo(year);

        requestInfluences(year, function(influences){
          renderInfluencesInMap(influences);
        });
      }
    });
  }
  init();
});
