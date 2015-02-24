$(function(){
  handleAddReminder()
  reloadCallPage()
})

handleAddReminder = function(){
  $("#btn-add-reminder").on('click', function(){
    var url = $("#form-add-reminder").attr("action")
    var phone_number= $("#input-phone_number").val()
    $alert = $("#alert-add-reminder")
    $alert.hide()

    var data = {phone_number: phone_number}
    $.ajax({
      url: url,
      method: 'POST',
      dataType: 'json',
      data: data,
      success: function(response){
        $alert.html(response['message'])

        if(response['status'] == 0) {
          setNotification("alert", response['message'])
          $alert.css('color', 'red')
        }
        else {
          setNotification("notice", response['message'])
          $alert.css('color', 'green')
        }

        $alert.show()
      }
    })
    return false;
  })
}

function reloadCallPage() {
  $('#new-reminder').on('hidden.bs.modal', function () {
    window.location.reload()
  })
}
