$().ready(function(){

  var $locationsContainer = $(".location.container");

  function removeLocation(locationId){
    if(locationId != ""){
      var html = '<input type="hidden" name="influencer[excluded_locations][]" value="'+locationId+'" />';
      $locationsContainer.append(html);
    }
  }

  function appendLocation(){
    var html = ''+
      '<div class="four fields">'+
        '<div class="field">'+
          '<input type="text" value="" name="influencer[new_locations][][name]" />'+
        '</div>'+
        '<div class="field">'+
          '<input type="text" value="" name="influencer[new_locations][][begin_in]" />'+
        '</div>'+
        '<div class="field">'+
          '<input type="text" value="" name="influencer[new_locations][][end_in]" />'+
        '</div>'+
        '<div class="field">'+
          '<button class="ui icon button remove-location" data-location-id=""><i class="icon minus"></i></button>'+
        '</div>'+
      '</div>';

    $locationsContainer.append(html);
  }

  $(".add-location").click(function(e){
    e.preventDefault();
    appendLocation();
  })
  $(".form.influencer").on('click', '.remove-location', function(e){
    e.preventDefault();
    removeLocation($(this).data("location-id"));
    $(this).parent().parent().remove()
  })
});
