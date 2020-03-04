$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })
});

import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", id: gon.question_id },{
  received(data) {
    $('.answers').append(data)
  }
})
