module QuestionsHelper

  def for_author_question_add_link_delete(question)
    if can?(:delete, question)
      link_to 'Delete question', question_path(question), method: :delete
    end
  end

  def subscribe_link(question)
    if current_user.subscriptions.exists?(question.id)
       link_to 'unsubscribe', subscribe_question_path(question), method: :patch, class: "subscription", remote: true
    else
       link_to 'subscribe', subscribe_question_path(question), method: :patch, class: "subscription", remote: true
    end
  end
end
