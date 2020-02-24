$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  $('form.new-answer').on('ajax:success', function(event){
    var  xhr = event.detail[2];

    $('.answers').append(xhr.responseText);
  })
    .on('ajax:error', function(event){
      var  xhr = event.detail[2];

      $('.answer-errors').html(xhr.responseText)
    })

});
