$(function(){
  clearForm()
  handleAddReminder();
  reloadCallPage();
});

function clearForm(){
  $('#new-reminder').on('shown.bs.modal', function (e) {
    $("#form-add-reminder")[0].reset()
    return true
  })
}

handleAddReminder = function(){
  $("#btn-add-reminder").on('click', function(){
    var phoneNumber= $("#call_phone_number").val();
    if(phoneNumber == null || phoneNumber == "") {
      showNotification("alert", "Phone number can't be blank");
      return false;
    };

    $.ajax({
      url: RootUrl + "calls/" + phoneNumber,
      method: 'GET',
      dataType: 'json',
      success: function(response) {
        if(response) {
          var yes = confirm("Phone number " + phoneNumber + " was reminded on " + dateToString(getDate(response['created_at'])) + ", do you want to make another reminder");
          if(yes) {
            submit();
          }
        } else {
          submit();
        }
      }
    })

    return false;
  });
};

function submit() {
  $alert = $("#alert-add-reminder");
  $alert.hide();
  
  var phoneNumber= $("#call_phone_number").val();
  if(phoneNumber == null || phoneNumber == "") {
    showNotification("alert", "Phone number can't be blank");
    return;
  };

  var familyCode= $("#call_family_code").val();
  if(familyCode == null || familyCode == "") {
    showNotification("alert", "Family code can't be blank");
    return;
  };

  var fullName= $("#call_full_name").val();

  var expirationDate= $("#call_expiration_date").val();
  if(!isDateFormat(expirationDate)) {
    showNotification("alert", "Expiration date can't be blank");
    return;
  };

  var kind = $("#call_kind").val();
  if(kind == null || kind == "") {
    showNotification("alert", "Kind can't be blank");
    return;
  };

  var url = $("#form-add-reminder").attr("action");

  var data = {
    call: {
      phone_number: phoneNumber,
      family_code: familyCode,
      full_name: fullName,
      expiration_date: expirationDate,
      kind: kind
    }
  };

  $.ajax({
    url: url,
    method: 'POST',
    dataType: 'json',
    data: data ,
    success: function(response){
      if(response['status'] == 0) {
        showNotification('alert', response['message']);
      } else {
        showNotification('notice', response['message']);
      }
    }
  });
};

function showNotification(type, value) {
  $alert = $("#alert-add-reminder");
  $alert.html(value);
  setNotification(type, value);
  $alert.css('color', type == 'alert' ? 'red' : 'green');
  $alert.show();
};

function reloadCallPage() {
  $('#new-reminder').on('hidden.bs.modal', function () {
    window.location.reload()
  })
};
