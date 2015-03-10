$(function() {
  allowKeyInput($(".numeric"), /[0-9]/);
  allowKeyInput($(".time"), /[0-9:]/);
  connectToVerboice();
});

function connectToVerboice() {
  $("#btn-verboice-connect").on('click', function(){
    $this = $(this)
    var url = $this.attr("href")
    var email = $("#email").val()
    var password = $("#password").val()

    var data = { email: email, password: password}
    setNotification("info", "Connecting to Verboice server")
    $.ajax({
      method: 'PUT',
      url: url,
      data: data,
      dataType: 'json',
      success: function(response){
        setNotification("notice", "Successfully Connected to verboice")
        window.location.reload()
      },
      error: function(response){
        setNotification('alert', "Failed to connect to verboice")
      }
    })
    return false
  })
}