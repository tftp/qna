$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  $('form.new-answer').on('ajax:success', function(event){
    var  answer = event.detail[0];

    $('.answers').append('<p>'+answer.body+'</p>');
  })
    .on('ajax:error', function(event){
      var  errors = event.detail[0];

      $.each(errors, function(index, value){
        $('.answer-errors').append('<p>' + value + '</p>');
      })
    })

});
