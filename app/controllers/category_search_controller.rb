require 'uri'
require 'open-uri'
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

    category_members.each do |article|
      article_url = "https://en.wikipedia.org?curid=#{article['pageid']}"
      doc = Nokogiri::HTML(open(article_url))

      paragraph = doc.css('p', 'article', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'a').map(&:text)
      score = Odyssey.flesch_kincaid_re(para.join('. '), false)
      article["readability"] = score
    end

    p category_members

    render partial: "search_results", locals: {category_members: category_members}
  end


end
