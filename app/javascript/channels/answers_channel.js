$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(editAnswer) {
    editAnswer.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })
});
