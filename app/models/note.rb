class Note < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :collection
  has_many :shared_notes
  has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", thumb: "150x150#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

end
