function isDateFormat(str){
  if(str == null || str == "") return false;

  var regex = str.match(/^(\d{4})[\/\-](\d{2})[\/\-](\d{2})$/);
  if(regex == null){
    return false;
  }
  
  return true;
};

function getDate(dateTimeStr) {
  var dtArr = dateTimeStr.split("T");

  if(dtArr.length <= 0) return null;

  var date = new Date(Date.parse(dtArr[0]));

  return date;
}

function dateToString(date) {
  var year = date.getFullYear();
  var month = date.getMonth() + 1;
  var day = date.getDate();
  return date.getFullYear() + "-" + (month < 10 ? "0" : "") + month + "-" + date.getDate();
}
