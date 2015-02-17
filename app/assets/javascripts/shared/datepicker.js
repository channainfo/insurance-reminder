$(function(){
  initDatePicker()
})

function initDatePicker(){
  $('.date-picker').datepicker({
    format: "yyyy-mm-dd"
  });
}