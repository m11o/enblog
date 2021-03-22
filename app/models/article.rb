# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  code         :string(255)      not null
#  title        :string(255)      not null
#  description  :text(65535)
#  body         :text(16777215)   not null
#  language     :integer          default("japanese"), not null
#  state        :integer          default("closed"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_articles_on_code  (code) UNIQUE
#
class Article < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :code, presence: true, uniqueness: { case_sensitive: true }
  validates :title, presence: true
  validates :body, presence: true
  validates :language, presence: true
  validates :state, presence: true

  before_validation :generate_code

  enum language: {
    japanese: 0,
    english: 1
  }

  enum state: {
    closed: 0,
    opened: 1
  }

  private

  def generate_code
    return if code.present?

    code = "A%09d" % SecureRandom.random_number(10**9)
    generate_code and return if Article.exists? code: code

    self.code = code
  end
end
