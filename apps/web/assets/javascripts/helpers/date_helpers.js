function formatDate(date){
  var dd = ("0" + date.getDate()).slice(-2),
      mm = ("0" + (date.getMonth() + 1)).slice(-2),
      yyyy = date.getFullYear();

  return (yyyy + '-' + mm + '-' + dd);
}

function changeDateYear(date, amount){
  if(typeof date === 'string') { date = new Date(date) }

  date.setFullYear(date.getFullYear() + amount);
  return formatDate(date);
}

function differenceInYearsBetween(today, pastDate){
  var difference = today.getFullYear() - pastDate.getFullYear();
  var m = today.getMonth() - pastDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < pastDate.getDate())) {
      difference--;
  }
  return difference
}
