function updateODReminder(id){
	$.ajax({
    url: RootUrl + "operational_districts/update_status.json",
    method: 'POST',
    dataType: 'json',
    data: {"id" : id},
    complete: function(response) {
    }
  });
}