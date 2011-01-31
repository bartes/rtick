class Manager

  def self.copy_rt_to_rm(mon, year, rt = nil, rm = nil)
    rt ||= Rubytime.first
    rm ||= Redmine.first
    rm_agent = rm.sign_in
    rt_agent = rt.sign_in
    data = rt.get_for_month(rt_agent, mon, year)
    data.each do |item_data|
      rm.update(rm_agent, item_data)
    end
  end


  def self.copy_rt_to_ts(mon, year, rt = nil, ts = nil)
    rt ||= Rubytime.first
    ts ||= Tickspot.first
    rt_agent = rt.sign_in
    data = rt.get_for_month(rt_agent, mon, year)
    data.each do |item_data|
      ts.update(item_data)
    end
  end

end
