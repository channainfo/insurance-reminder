$(function(){
  flashNotification();
})

function flashNotification(){
  setNotification(Config.Flash.key, Config.Flash.value)
}

function setNotification(key, value) {
  $notification = $("#notification")

  if(key && value){
    var templateData = {body: value}

    if(key == 'notice'){
      templateData.title = "Success"
      templateData.type = 'info'
      templateData.icon = 'ok'
    }
    else{
      templateData.title = "Failure"
      templateData.type = 'danger'
      templateData.icon = 'remove'
    }
    $notification.show()
    var notificationHtml = tmpl('tmpl-notification', templateData)
    $notification.html(notificationHtml)
    $notification.fadeOut(2000)
  }
  else{
    $notification.hide();
  }
}