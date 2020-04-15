$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('form#edit-question').show();
  })
});

import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel",{
  received(data) {
    $('.questions').append(data)
  }
})
