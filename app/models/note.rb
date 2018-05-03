class Note < ActiveRecord::Base
	belongs_to :user
	has_many :shared_notes
end
