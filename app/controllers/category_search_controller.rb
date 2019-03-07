require 'uri'
require 'net/http'

class CategorySearchController < ApplicationController
  def index
    render 'index'
  end

  def create
    category = params[:category]
    url = URI("https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&cmtitle=Category%3A#{params[:category]}&format=json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    category_members = JSON.parse(response.read_body)['query']['categorymembers']
  end


end
