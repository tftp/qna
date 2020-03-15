import consumer from "./consumer"
const Handlebars = require("handlebars")

consumer.subscriptions.create({ channel: "CommentsChannel", id: gon.question_id },{
  received(data) {
    this.addComment(data);
  },
  addComment(data){
    if (gon.user_id === data.comment.user_id) return;
    var template = Handlebars.compile( $('#comment-template').html() );
    if (data.comment.commentable_type === 'Question'){
      $('.comments-question').before(template(data));
    }else{
      $(".comments-answer-"+data.comment.commentable_id).before(template(data))

    }
  }
});
