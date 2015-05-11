$(function(){
  $('.btn-hidden-content').on('click', function(){
    $elm = $(this)
    $elmRef = $("#" + $elm.attr('data-ref-id'))

    if($elmRef.attr('type') == 'password') {
      $elmRef.attr('type', 'text')
      $elm.text('Hide')
    }
    else {
      $elmRef.attr('type', 'password');
      $elm.text('Show')
    }
    return false;
  })
})