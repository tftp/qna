import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", id: gon.question_id },{
  received(data) {
    this.addComment(data);
  },
  addComment(data){
    if (gon.user_id == data.comment.user_id) return;
    if (data.comment.commentable_type === 'Question'){
      $('.comments-question').before("<p>" + data.comment.body + "</p>");
    }else{
      $(".comments-answer-"+data.comment.commentable_id).before("<p>" + data.comment.body + "</p>")

    }
  }
});
