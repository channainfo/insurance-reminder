$(function() {
  allowKeyInput($(".numeric"), /[0-9]/);
  allowKeyInput($(".time"), /[0-9:]/);
});