# == Schema Information
#
# Table name: rubytimes
#
#  id         :integer         not null, primary key
#  login      :string(255)
#  password   :string(255)
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class RubytimeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
