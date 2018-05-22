class Note < ApplicationRecord
  belongs_to :owner, :class_name => "User", :foreign_key => 'owner_id'
  has_and_belongs_to_many :users
  has_and_belongs_to_many :collections
  has_many :shared_notes
  has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", thumb: "50x50#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
