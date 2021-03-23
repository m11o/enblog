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
  MAX_RECOMMEND_ARTICLES_COUNT = 5

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
    tag_names ||= []
    delete_tag_ids = will_delete_tag_ids tag_names
    article_tags.where(tag_id: delete_tag_ids).destroy_all
    tag_names.each { |tag_name| append_tag tag_name }
  end

  def recommend_articles
    Article.joins(:tags).where(tags: tags).order(published_at: :desc).distinct.limit(MAX_RECOMMEND_ARTICLES_COUNT)
  end

  def published_at
    read_attribute(:published_at).presence || updated_at
  end

  private

  def generate_code
    return if code.present?

    code = format 'A%09d', SecureRandom.random_number(10**9)
    generate_code and return if Article.exists? code: code

    self.code = code
  end

  def append_tag(tag_name)
    tag = Tag.find_or_create_by! name: tag_name
    return if tag.persisted? && article_tags.exists?(tag_id: tag.id)

    article_tags.build tag_id: tag.id
  end

  def will_delete_tag_ids(tag_names)
    tags.map { |tag| tag_names.include?(tag.name) ? nil : tag.id }.compact
  end
end
