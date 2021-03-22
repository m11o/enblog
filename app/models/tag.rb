# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :article_tag, dependent: :destroy
  has_many :article, through: :article_tag

  validates :name, presence: true
end
