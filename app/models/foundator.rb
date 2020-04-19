class Foundator
  MODEL = %w[question answer comment user all]

  def self.search(query, model)
    return [] unless MODEL.include? model
    return ThinkingSphinx.search query, classes: [Question, Answer, Comment, User] if model == 'all'
    model.classify.constantize.search ThinkingSphinx::Query.escape(query)
  end

end
