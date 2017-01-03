var Form = function(form_selector){
  var public_methods = {
    addCollectionFields: function(wrapper, entity_name, fields) {
      var html = "", self = this;

      $.each(fields, function(i, field){
        if(field.fields){
          var composed_name = entity_name + "[][" + field.name + "]";
          self.addCollectionFields(wrapper, composed_name, field.fields);

        } else if(field.type == "text"){
          html+= ""+
            "<div class='field'>"+
            "<label>"+field.label+"</label>"+
            "<input type='text' name='"+entity_name+"[]["+field.name+"]' />"+
            "</div>";
        }
      });

      wrapper.append(html)
    }
  }

  return public_methods;
}
