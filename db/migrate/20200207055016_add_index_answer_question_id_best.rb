class AddIndexAnswerQuestionIdBest < ActiveRecord::Migration[6.0]
  def change
    add_index :answers, [:question_id], unique: true, where: 'best = true', name: 'answers_question_id_best_true'
  end
end
