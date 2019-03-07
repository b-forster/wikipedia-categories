class CategorySearchController < ApplicationController
  def index
    render 'index'
  end

  def search
    p "%" * 50
    p params
    p "%" * 50
  end
end
