function renderSlider(range, callbacks){
  var bigValueSlider = document.getElementById('slider-huge'),
      bigValueSpan = document.getElementById('huge-value');

  noUiSlider.create(bigValueSlider, {
    start: 0,
    step: 1,
    orientation: 'vertical',
    format: wNumb({
      decimals: 0
    }),
    range: {
      min: 0,
      max: range.length-1
    }
  });

  bigValueSlider.noUiSlider.on('update', function ( values, handle ) {
    var currentValue = range[values[handle]]
    bigValueSpan.innerHTML = currentValue;
    callbacks.onUpdate(currentValue);
  });
}
