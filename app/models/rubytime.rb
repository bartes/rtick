require 'mechanize'

class Rubytime < ActiveRecord::Base

  validates :password, :presence => true
  validates :login, :presence => true
  
  def self.sign_in(agent, rubytime)
    page = agent.get('http://rt.llp.pl/login')
    # Fill out the login form
    form = page.forms.detect{|f| f.action == '/login'}
    raise "Form /login not found!" unless form
    form.login = rubytime.login
    form.password = rubytime.password
    agent.submit(form)
  end
  
  def sign_in
    agent = Mechanize.new
    self.class.sign_in(agent, self)
  end
end
