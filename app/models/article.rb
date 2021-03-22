# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  code         :string(255)      not null
#  title        :string(255)      not null
#  description  :text(65535)
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

  accepts_nested_attributes_for :article_tags

  has_rich_text :body

  validates :code, presence: true, uniqueness: { case_sensitive: true }
  validates :title, presence: true
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

  def append_tags(tag_names)
    return if tag_names.blank?

    tag_names.map { |tag_name| append_tag tag_name }
  end

  private

  def generate_code
    return if code.present?

    code = "A%09d" % SecureRandom.random_number(10**9)
    generate_code and return if Article.exists? code: code

    self.code = code
  end

  def append_tag(tag_name)
    tag = Tag.find_or_create_by! name: tag_name
    article_tags.build tag_id: tag.id
  end
end
