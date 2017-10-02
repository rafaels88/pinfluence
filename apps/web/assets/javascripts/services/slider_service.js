var bigValueSlider = document.getElementById('slider-huge'),
    bigValueSpan = document.getElementById('huge-value'),
    increaseBtn = document.getElementById('slider-increase'),
    decreaseBtn = document.getElementById('slider-decrease'),
    changeCurrentYearBtn = document.getElementsByClassName('change-current-year')[0],
    sliderRange, currentYear, yearFormActive = false, slider;

function renderSlider(years, callbacks){
  sliderRange = years.map(function(year){ return year.year });
  currentYear = sliderRange[0];
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
    currentYear = sliderRange[values[handle]];
    callbacks.onChange(currentYear);
  });

  bigValueSlider.noUiSlider.on('update', function ( values, handle ) {
    var currentYearLabel = years[values[handle]].formatted;
    changeValueLabel(currentYearLabel);
  });

  $(increaseBtn).off('click').on('click', function(){
    var currentSliderValue = bigValueSlider.noUiSlider.get();

    if(currentSliderValue < maxSliderValue){
      currentYear = parseInt(sliderRange[currentSliderValue], 10) + 1;

      bigValueSlider.noUiSlider.set(parseInt(currentSliderValue, 10) + 1);
      callbacks.onChange(currentYear);
    }
  });

  $(decreaseBtn).off('click').on('click', function(){
    var currentSliderValue = bigValueSlider.noUiSlider.get();

    if(currentSliderValue > 0){
      currentYear = parseInt(sliderRange[currentSliderValue], 10) - 1;

      bigValueSlider.noUiSlider.set(parseInt(currentSliderValue, 10)-1);
      callbacks.onChange(currentYear);
    }
  });

  $(changeCurrentYearBtn).off('click').on('click', function(){
    if(yearFormActive == false){
      yearFormActive = true;

      $(this).find("input").val(Math.abs(currentYear))

      if(currentYear < 0){
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

function listenRequestYear(callback){
  $(changeCurrentYearBtn).find("form").submit(function(e){
    e.preventDefault();
    var requestedYear = parseInt($(this).find("input").val(), 10),
        requestedTimeLabel = $(this).find(".option-time-label").text();

    if(!isNaN(requestedYear)){
      if(requestedTimeLabel.toUpperCase().trim() == "BC"){
        requestedYear = -Math.abs(requestedYear)
      } else {
        requestedYear = Math.abs(requestedYear)
      }

      yearFormActive = false;
      $(changeCurrentYearBtn).find(".input").addClass('hide');
      $(changeCurrentYearBtn).find("span, label").removeClass('hide');

      callback.onSearch(requestedYear);
    }
  });
}

function changeSliderTo(year){
  var index = sliderRange.indexOf(year);
  currentYear = year;
  bigValueSlider.noUiSlider.set(index);
}

function changeValueLabel(value){
  bigValueSpan.innerHTML = value;
}
