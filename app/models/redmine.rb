# == Schema Information
#
# Table name: redmines
#
#  id         :integer         not null, primary key
#  login      :string(255)
#  password   :string(255)
#  job        :string(255)
#  project    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'mechanize'

class Redmine < ActiveRecord::Base

  validates :login, :password, :job, :project , :presence => true

  def self.path
    "https://dev.truvolabs.com"
  end

  def sign_in
    agent = Mechanize.new
    page = agent.get(File.join(self.class.path, 'login'))
    form = page.forms.detect{|f| f.action == '/login'}
    raise "Form /login not found!" unless form
    form["username"] = login
    form["password"] = password
    agent.submit(form)
    agent
  end

  def put(agent, data)
    page = agent.get("#{self.class.path}/projects/#{project}/time_entries/new")
    form = page.forms.detect{|f| f.action == "/projects/#{project}/timelog/edit"}
    raise "Form not found!" unless form
    form["time_entry[activity_id"] = activity_id
    date = data[:date]
    date = date.split("-").reverse.join("-") if date.to_s.split("-").first.size == 2
    form["time_entry[spent_on]"] = date
    form["time_entry[hours]"] = data[:time]
    form["time_entry[comments]"] = data[:text]
    agent.submit(form)
    agent
  end

  def activity_id
    case job
    when "designer"
      8
    when "project_manager"
      10
    when "tester"
      11
    else "developer"
      9
    end
  end
end
