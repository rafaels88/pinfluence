function formatDate(date){
  var dd = ("0" + date.getDate()).slice(-2),
      mm = ("0" + (date.getMonth() + 1)).slice(-2),
      yyyy = date.getFullYear();

  return (yyyy + '-' + mm + '-' + dd);
}

function splitDate(date){
  var dateIsNegative = false;

  if(date[0] === '-') {
    date = date.replace('-', '');
    dateIsNegative = true;
  }

  var dateNums = date.split('-');

  if(dateIsNegative){ dateNums[0] = '-' + dateNums[0]; }

  return dateNums;
}

function changeDateYear(date, amount){
  if(typeof date === 'string') { date = new Date(date) }

  date.setFullYear(date.getFullYear() + amount);
  return formatDate(date);
}

function differenceInYearsBetween(today, pastDate){
  var todayNums = splitDate(today),
    pastDateNums = splitDate(pastDate),
    difference;

  today = moment([todayNums[0], todayNums[1], todayNums[2]]);
  pastDate = moment([pastDateNums[0], pastDateNums[1], pastDateNums[2]]);
  difference = moment.range(pastDate, today).diff('years');

  if(pastDate.year() < 0 && today.year() > 0) { difference--; }

  return difference;
}
