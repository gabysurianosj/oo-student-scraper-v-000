require 'nokogiri '
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
     students_index = Nokogiri::HTML(open("./fixtures/student-site/index.html"))
    students = []
    students_index.css(".student-card").each do |student|
      student_name = student.css("h4.student-name").text
      student_location = student.css("p.student-location").text
      profile_url = student.css("a").attribute("href").value
      student_attributes = {:name => student_name, :location => student_location, :profile_url => profile_url}
      students << student_attributes
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_slug))
    links = profile_page.css(".social-icon-container").children.css("a").map { |elm| elm.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")
     student
    end 
  end
end 

