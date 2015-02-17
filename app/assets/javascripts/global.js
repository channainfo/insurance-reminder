function allowKeyInput(elements, pattern) {
  $(elements).controlKeyInput({
    allowChar: pattern,
    allow: function(input, char){
      if(char == "+" && ($.caretPosition(input) !=0 || input.value.indexOf(char) != -1 ))
        return false;
      return true;
    }
  });
};
