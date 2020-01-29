module AnswersHelper

  def for_author_answer_add_link_delete(answer)
    if current_user.is_author?(answer)
      link_to 'Delete answer', question_answer_path(answer.question), method: :delete
    end
  end
end
