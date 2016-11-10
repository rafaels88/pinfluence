var bigValueSlider = document.getElementById('slider-huge'),
    bigValueSpan = document.getElementById('huge-value'),
    increaseBtn = document.getElementById('slider-increase'),
    decreaseBtn = document.getElementById('slider-decrease'),
    sliderRange;

function renderSlider(range, formattedRange, callbacks){
  sliderRange = range;
  var maxSliderValue = sliderRange.length-1;

  noUiSlider.create(bigValueSlider, {
    start: 0,
    step: 1,
    orientation: 'vertical',
    format: wNumb({ decimals: 0 }),
    range: {
      min: 0,
      max: maxSliderValue
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

  increaseBtn.addEventListener('click', function(){
    var currentSliderValue = bigValueSlider.noUiSlider.get();

    if(currentSliderValue < maxSliderValue){
      bigValueSlider.noUiSlider.set(parseInt(currentSliderValue, 10)+1);
      callbacks.onChange(parseInt(sliderRange[currentSliderValue], 10)+1)
    }
  });

  decreaseBtn.addEventListener('click', function(){
    var currentSliderValue = bigValueSlider.noUiSlider.get();

    if(currentSliderValue > 0){
      bigValueSlider.noUiSlider.set(parseInt(currentSliderValue, 10)-1);
      callbacks.onChange(parseInt(sliderRange[currentSliderValue], 10)-1)
    }
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
