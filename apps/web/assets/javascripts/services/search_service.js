var $searchForm = $("#search-form");

function listenSearch(callbacks){
  $searchForm.submit(function(e){
    e.preventDefault();
    console.log()
    var term = $(this).find("#search-field").val();
    callbacks.onSearch(term);
  });
}
