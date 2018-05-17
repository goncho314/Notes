class User < ActiveRecord::Base
  has_many :notes
  has_many :collections
  has_many :shared_notes
  has_many :being_shared_notes, :class_name => "Shared_note", :foreign_key => "sharedUser"
  has_friendship
end
