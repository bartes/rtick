require "mechanize"

class Tickspot < ActiveRecord::Base

  validates :password, :presence => true
  validates :login, :presence => true

  def self.sign_in(agent, tickspot)
    page = agent.get('https://truvolabs.tickspot.com/login')

    form = page.forms.detect{|f| f.action == '/login'}
    raise "Form /login not found!" unless form
    form.user_login = tickspot.login
    form.user_password = tickspot.password

    agent.submit(form)
  end

  def sign_in
    agent = Mechanize.new
    self.class.sign_in(agent, self)
  end


end
