$(document).on('turbolinks:load', function(){

  $('a.vote-pisitive-link').on('ajax:success', function(event){
    var  vote = event.detail[0];
    var answerId = $(this).data('answerId');
    var questionId = $(this).data('questionId');

    $('.vote-mark-question#'+questionId).html(vote)
    $('.vote-mark-answer#'+answerId).html(vote)

  })
  .on('ajax:error', function(event){
    var  errors = event.detail[0];

    $.each(errors, function(index, value){
      if (answerId) $('.answer-errors').append('<p>' + value + '</p>');
      if (questionId) $('.question-errors').append('<p>' + value + '</p>');
    })
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

    $.each(errors, function(index, value){
      if (answerId) $('.answer-errors').append('<p>' + value + '</p>');
      if (questionId) $('.question-errors').append('<p>' + value + '</p>');
    })
  })

});
