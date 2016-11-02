var bigValueSlider = document.getElementById('slider-huge'),
    bigValueSpan = document.getElementById('huge-value'),
    sliderRange;

function renderSlider(range, formattedRange, callbacks){
  sliderRange = range;

  noUiSlider.create(bigValueSlider, {
    start: 0,
    step: 1,
    orientation: 'vertical',
    format: wNumb({ decimals: 0 }),
    range: {
      min: 0,
      max: sliderRange.length-1
    }
  });

  bigValueSlider.noUiSlider.on('change', function ( values, handle ) {
    var currentValue = sliderRange[values[handle]];
    callbacks.onChange(currentValue);
  });

  bigValueSlider.noUiSlider.on('update', function ( values, handle ) {
    var currentValue = formattedRange[values[handle]];
    changeValueLabel(currentValue);
  });

  callbacks.onInit();
}

function changeSliderTo(year){
  var index = sliderRange.indexOf(year);
  bigValueSlider.noUiSlider.set(index);
}

function changeValueLabel(value){
  bigValueSpan.innerHTML = value;
}
