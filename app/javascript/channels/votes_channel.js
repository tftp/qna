$(document).on('turbolinks:load', function(){

  $('a.vote-pisitive-link').on('ajax:success', function(event){
    var  vote = event.detail[0];
    var answerId = $(this).data('answerId');
    var questionId = $(this).data('questionId');
    console.log(vote)
    console.log(answerId)
    console.log(questionId)

  })

  $('a.vote-negative-link').on('ajax:success', function(event){
    var  vote = event.detail[0];
    var answerId = $(this).data('answerId');
    var questionId = $(this).data('questionId');
    console.log(vote)
    console.log(answerId)
    console.log(questionId)

  })


});
