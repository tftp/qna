class SearchController < ApplicationController

  skip_authorization_check

  def index
    @result = SearchCenter.search(params_search, params_model)
  end

  private


  def params_search
    params['query'].empty? ? '' : params.require('query')
  end

  def params_model
    params.require('model')
  end
end
