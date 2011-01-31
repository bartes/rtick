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

require 'test_helper'

class RedmineTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
