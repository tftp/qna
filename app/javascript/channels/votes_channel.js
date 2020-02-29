$(document).on('turbolinks:load', function(){

  $('a.vote-change-link').on('ajax:success', function(event){
    var  vote = event.detail[0];
    var votableType = $(this).data('votableType');
    var votableId = $(this).data('votableId');

    $('.vote-mark-'+votableType+'#'+votableId).html(vote)

  })
  .on('ajax:error', function(event){
    var  errors = event.detail[0];
    var votableType = $(this).data('votableType');

    $('.' + votableType + '-errors').append('<p>' + errors + '</p>');
  })


});
