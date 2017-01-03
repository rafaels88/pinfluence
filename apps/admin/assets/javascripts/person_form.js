$().ready(function(){
  var personForm = new Form($(".person-form"));

  var location_fields = [
    { type: "text", name: "address", label: "Location" },
    { type: "text", name: "density", label: "Density" }
  ];

  var moment_fields = [
    { type: "text", name: "year_begin", label: "Begin in (year)" },
    { type: "text", name: "year_end", label: "End in (year)" },
    { name: "locations", fields: location_fields },
  ]

  $(".button.add-moment").click(function(e){
    e.preventDefault();
    personForm.addCollectionFields($(".moments-fields"), "moments", moment_fields);
  })
})
