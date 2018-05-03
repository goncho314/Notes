class SharedNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :sharedUser, :class_name => "User", :foreign_key => "sharedUser"
  belongs_to :note
end
