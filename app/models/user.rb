class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :institute_name, :is_direct, :mobile_no, :max_tests, :is_admin, :is_guest
  # attr_accessible :title, :body

  has_many :test_details
  has_many :test_results
end
