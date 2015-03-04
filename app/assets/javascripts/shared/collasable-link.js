$(function(){
  initCollasable()
})


function initCollasable(){
  $(".collasable-link").on('click', function(){
    $this = $(this)
    $container = $this.parent().find(".collasable-container")
    $container.toggle(500)
    return false;
  })
}