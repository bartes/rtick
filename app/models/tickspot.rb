# == Schema Information
#
# Table name: tickspots
#
#  id         :integer         not null, primary key
#  login      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "mechanize"
require "net/http"

class Tickspot < ActiveRecord::Base

  validates :password, :presence => true
  validates :login, :presence => true

  def self.path
    "https://truvolabs.tickspot.com"
  end

  def sign_in
    agent = Mechanize.new
    page = agent.get("#{self.class.path}/login")

    form = page.forms.detect{|f| f.action == "/login"}
    raise "Form /login not found!" unless form
    form.user_login = login
    form.user_password = password

    agent.submit(form)
    agent
  end

  def self.format_time(hours, minutes)
    sprintf('%02d:%02d', hours, minutes)
  end

  def api_request(path, params = {})
    request = Net::HTTP::Post.new("/api/" + path)
    request.form_data = {
        'email' => login,
        'password' => password
    }.merge(params)

    result = nil
    Net::HTTP.new(self.class.path).start {|http|
      response = http.request(request)
      result = response.body
      code = response.code.to_i
      raise "Request failed with code: #{code} and message #{response.body}" unless code < 300 && code >= 200
    }
    result
  end


  def put(data)
    txt = api_request('projects', :open => true)
    #doc = Nokogiri::XML.parse(txt)
    #clients = parse_tickspot_clients(doc)
    #client_id, client = get_tickspot_selected_id(config, clients.values, 'Client')
    #project_id, project = get_tickspot_selected_id(config, client[:projects], 'Project')
    #task_id, task = get_tickspot_selected_id(config, project[:tasks], 'Task')

    api_request( 'create_entry', :task_id => task_id, :hours => data[:time], :date => data[:date], :notes => data[:text])
  end

  def parse_tickspot_clients(doc)
    clients = {}
    doc.css('project').each do |project_elem|
      client = parse_client(project_elem)
      clients[client[:id]] ||= client
      project = parse_project(project_elem)
      clients[client[:id]][:projects] << project
      project_elem.css('task').each do |task|
        project[:tasks] << parse_task(task)
      end
    end
    clients
  end

  def task_id
    317764.to_s #hardcoded
  end
end
