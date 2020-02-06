$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(editQuestion) {
    editQuestion.preventDefault();
    $(this).hide();
    $('form#edit-question').show();
  })
});
