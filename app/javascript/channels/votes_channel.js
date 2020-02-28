$(document).on('turbolinks:load', function(){

  $('a.vote-positive-link').on('ajax:success', function(event){
    var  vote = event.detail[0];
    var answerId = $(this).data('answerId');
    var questionId = $(this).data('questionId');

    $('.vote-mark-question#'+questionId).html(vote)
    $('.vote-mark-answer#'+answerId).html(vote)

  })
  .on('ajax:error', function(event){
    var  errors = event.detail[0];

    if (answerId) $('.answer-errors').append('<p>' + errors + '</p>');
    if (questionId) $('.question-errors').append('<p>' + errors + '</p>');
  })

  $('a.vote-negative-link').on('ajax:success', function(event){
    var  vote = event.detail[0];
    var answerId = $(this).data('answerId');
    var questionId = $(this).data('questionId');

    $('.vote-mark-question#'+questionId).html(vote)
    $('.vote-mark-answer#'+answerId).html(vote)

  })
  .on('ajax:error', function(event){
    var  errors = event.detail[0];

    if (answerId) $('.answer-errors').append('<p>' + errors + '</p>');
    if (questionId) $('.question-errors').append('<p>' + errors + '</p>');
  })

});
