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

      doc = Nokogiri::HTML(open(article_url)).xpath("//text()").to_s.strip.gsub(/\W/," ")
      score = TextStat.flesch_reading_ease(doc)

      article["readability"] = score
    end

    p sorted_articles = category_members.sort_by!{|article| article["readability"]}

    render partial: "search_results", locals: {category_members: sorted_articles}
  end


end
