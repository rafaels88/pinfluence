var $searchForm = $("#search-form"), $searchContainer = $(".ui.search"),
  $results = $searchContainer.find(".results"), $searchField = $("#search-field"),
  $searchInputContainer = $searchContainer.find(".icon.input");

function listenSearch(callbacks){
  $searchForm.submit(function(e){
    e.preventDefault();
  });

  $(window).keyup(function(e){
    var tab = 9;
    if(e.keyCode === tab){
      hideSearchResults();
      hideSearchingLoading();
    }
  })

  $searchField.typeWatch({
    wait: 500,
    callback: function(value){
      var term = value.trim();
      showSearchingLoading();
      callbacks.onSearch(term);
    }
  });

  $results.on('click', '.result.clickable', function(){
    var year = $(this).data('year');
    callbacks.onSelectedResult(year);
    hideSearchResults();
  });

  $(window).mouseup(function(e){
    // if the target of the click isn't the container nor a descendant of the container
    if (!$searchContainer.is(e.target) && $searchContainer.has(e.target).length === 0){
      hideSearchResults();
      hideSearchingLoading();
    }
  });
}

function renderInfluencersSearchResult(influencers){
  if(!$searchField.is(':focus')){
    hideSearchingLoading();
    return;
  }

  var html = '', $results = $('.ui.search .results');

  if(influencers.people.length > 0){
    html += _buildSectionHtml('People');
    $.each(influencers.people, function(i, person){
      html += _buildInfluencerResultHtml(person);
    });
  }

  if(influencers.events.length > 0){
    html += _buildSectionHtml('Events');
    $.each(influencers.events, function(i, event){
      html += _buildInfluencerResultHtml(event);
    });
  }

  if(html !== ''){
    html += '' +
      '<a class="result image">' +
       '<div class="content">' +
        '<div class="title"><img src="https://www.algolia.com/static_assets/images/pricing/pricing_new/algolia-powered-by-14773f38.svg" /></div>' +
       '</div>' +
      '</a>';
  } else {
    html += '' +
      '<a class="result">' +
       '<div class="content">' +
         '<div class="title">No result found...</div>' +
       '</div>' +
      '</a>';
  }

  $results.html(html);
  hideSearchingLoading();
  showSearchResults();
}

function _buildInfluencerResultHtml(influencer){
  return '<a class="result clickable" data-year="'+influencer.earliest_year+'">' +
         '<div class="content">' +
           '<div class="title">'+influencer.name+'</div>' +
         '</div>' +
        '</a>';
}

function _buildSectionHtml(title){
  return '<a class="result section">' +
         '<div class="content">' +
           '<div class="title">'+title+'</div>' +
         '</div>' +
        '</a>';
}

function showSearchResults(){
  $results.addClass("transition visible").show();
}

function hideSearchResults(){
  $results.removeClass("transition visible").hide();
}

function showSearchingLoading(){
  $searchInputContainer.addClass("loading");
}

function hideSearchingLoading(){
  $searchInputContainer.removeClass("loading");
}
