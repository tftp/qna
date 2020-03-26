module QuestionsHelper

  def for_author_question_add_link_delete(question)
    if can?(:delete, question)
      link_to 'Delete question', question_path(question), method: :delete
    end
  end
end
