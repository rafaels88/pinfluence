var bigValueSlider = document.getElementById('slider-huge'),
    bigValueSpan = document.getElementById('huge-value'),
    increaseBtn = document.getElementById('slider-increase'),
    decreaseBtn = document.getElementById('slider-decrease'),
    changeCurrentDateBtn = document.getElementsByClassName('change-current-date')[0],
    sliderRange, currentDate, dateFormActive = false, slider;

function renderSlider(dates, callbacks){
  sliderRange = dates.map(function(date){ return date.date });
  currentDate = sliderRange[0];
  var maxSliderValue = sliderRange.length-1;

  if(slider){
    slider.destroy();
  }

  slider = noUiSlider.create(bigValueSlider, {
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
    currentDate = sliderRange[values[handle]];
    callbacks.onChange(currentDate);
  });

  bigValueSlider.noUiSlider.on('update', function ( values, handle ) {
    var currentDateLabel = dates[values[handle]].formatted;
    changeValueLabel(currentDateLabel);
  });

  $(increaseBtn).off('click').on('click', function(){
    var currentSliderValue = bigValueSlider.noUiSlider.get();

    if(currentSliderValue < maxSliderValue){
      currentDate = parseInt(sliderRange[currentSliderValue], 10) + 1;

      bigValueSlider.noUiSlider.set(parseInt(currentSliderValue, 10) + 1);
      callbacks.onChange(currentDate);
    }
  });

  $(decreaseBtn).off('click').on('click', function(){
    var currentSliderValue = bigValueSlider.noUiSlider.get();

    if(currentSliderValue > 0){
      currentDate = parseInt(sliderRange[currentSliderValue], 10) - 1;

      bigValueSlider.noUiSlider.set(parseInt(currentSliderValue, 10)-1);
      callbacks.onChange(currentDate);
    }
  });

  $(changeCurrentDateBtn).off('click').on('click', function(){
    if(dateFormActive == false){
      dateFormActive = true;

      $(this).find("input").val(Math.abs(currentDate))

      if(currentDate < 0){
        $(this).find(".option-time-label").text("BC")
      } else {
        $(this).find(".option-time-label").text("AD")
      }

      $(this).find("span, label").addClass('hide');
      $(this).find(".input").removeClass('hide');
    }
  });

  callbacks.onInit();
}

function listenRequestDate(callback){
  $(changeCurrentDateBtn).find("form").submit(function(e){
    e.preventDefault();
    var requestedDate = parseInt($(this).find("input").val(), 10),
        requestedTimeLabel = $(this).find(".option-time-label").text();

    if(!isNaN(requestedDate)){
      if(requestedTimeLabel.toUpperCase().trim() == "BC"){
        requestedDate = -Math.abs(requestedDate)
      } else {
        requestedDate = Math.abs(requestedDate)
      }

      dateFormActive = false;
      $(changeCurrentDateBtn).find(".input").addClass('hide');
      $(changeCurrentDateBtn).find("span, label").removeClass('hide');

      callback.onSearch(requestedDate);
    }
  });
}

function changeSliderTo(date){
  var index = sliderRange.indexOf(date);
  currentDate = date;
  bigValueSlider.noUiSlider.set(index);
}

function changeValueLabel(value){
  bigValueSpan.innerHTML = value;
}
