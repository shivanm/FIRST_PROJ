class TestResult < ActiveRecord::Base
  attr_accessible :obj_score, :sub_score, :total_score, :user_id

  belongs_to :user
  has_many :test_details
end
