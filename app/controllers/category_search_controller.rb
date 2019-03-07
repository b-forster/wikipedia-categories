class CategorySearchController < ApplicationController
  def index
    render 'index'
  end

  def create
    category = params[:category]
  end
end
