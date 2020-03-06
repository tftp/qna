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
      var template = Handlebars.compile( $('#answer-template').html() );
      document.querySelector('.answers').insertAdjacentHTML('beforeEnd', template(data));
    }
  })

});
