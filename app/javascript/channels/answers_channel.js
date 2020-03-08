import consumer from "./consumer"
const Handlebars = require("handlebars")

$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  consumer.subscriptions.create({ channel: "AnswersChannel", id: gon.question_id },{
    received(data) {
      this.addAnswer(data);
    },
    addAnswer(data){
      if (gon.user_id == data.answer.user_id) return;
      var template = Handlebars.compile( $('#answer-template').html() );
      data.is_question_author = gon.user_id == gon.question_author_id;
      data.question_id = gon.question_id
      $('.answers').append(template(data));
    }
  })

});
