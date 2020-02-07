module AnswersHelper

  def for_author_answer_add_link_delete(answer)
    if current_user.is_author?(answer)
      link_to 'Delete answer', question_answer_path(answer.question_id, answer.id), method: :delete
    end
  end

  def button_best(answer)

    if answer.best?
      button_to "#{answer.best?}", best_question_answer_path(answer.question, answer),
                  class: 'btn btn-success best-answer-link',
                  data: { answer_id: answer.id },
                  remote: true,
                  method: :patch
    else
      button_to "#{answer.best?}", best_question_answer_path(answer.question, answer),
                  class: 'btn btn-secondary best-answer-link',
                  data: { answer_id: answer.id },
                  remote: true,
                  method: :patch
    end
  end
end
