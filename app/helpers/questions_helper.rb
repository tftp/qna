module QuestionsHelper

  def for_author_question_add_link_delete(question)
    if can?(:delete, question)
      link_to 'Delete question', question_path(question), method: :delete
    end
  end

  def subscribe_link(question)
    subscription = current_user.subscriptions.find_by(question: question)
    if subscription
       link_to 'unsubscribe', question_subscription_path(subscription, question_id: question.id), method: :delete, class: "subscription", remote: true
    else
       link_to 'subscribe', question_subscriptions_path(question_id: question.id), method: :post, class: "subscription", remote: true
    end
  end
end
