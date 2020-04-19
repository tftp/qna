class SearchController < ApplicationController

  skip_authorization_check

  def index
    @result = Question.search params_search if params_model == 'question'
    @result = Answer.search params_search if params_model == 'answer'
    @result = Comment.search params_search if params_model == 'comment'
    @result = User.search params_search if params_model == 'user'
    @result = ThinkingSphinx.search params_search unless @result
  end

  private


  def params_search
    params['query'].empty? ? '' : params.require('query')
  end

  def params_model
    params.require('model')
  end
end
