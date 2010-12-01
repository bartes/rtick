require 'mechanize'

class Rubytime < ActiveRecord::Base

  validates :password, :presence => true
  validates :login, :presence => true
  
  def sign_in
    agent = Mechanize.new
    page = agent.get('http://rt.llp.pl/login')
    # Fill out the login form
    form = page.forms.detect{|f| f.action == '/login'}
    raise "Form /login not found!" unless form
    form.login = login
    form.password = password
    agent.submit(form)
    agent
  end
  
  def self.get_all_from_month(agent, mon, year) 
    timer = Time.zone.local(year, mon)
      
    page = agent.get(:url => 'http://rt.llp.pl/activities', :params => {
      :"search_criteria[date_from]" => format_date(timer.beginning_of_month),
      :"search_criteria[date_to]"   => format_date(timer.end_of_month)
    })
    
    parser = page.parser
    
    result = []

    activities = parser.css(".activities tr")
    activities.shift
    activities.pop

    activities.each do |a|
      tds = a.css("td")
      if tds.size == 3
        result << {:date => tds.first.text, :time => tds[1].text}
      else
        result.last[:text] = tds.css("p").last.text
      end 
    end
    result
  end


  def self.format_date(date)
    date.to_date.to_s(:db).split("-").reverse.join("-")
  end
end
