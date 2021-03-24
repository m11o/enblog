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

  before_update :insert_published_at

  enum language: {
    japanese: 0,
    english: 1
  }

  enum state: {
    closed: 0,
    opened: 1
  }

  class << self
    def s3_path(code, lang: :ja)
      "#{parent_directory(lang)}#{code}.html"
    end

    def front_content_path(code, lang: :ja)
      "/#{parent_directory(lang)}#{code}"
    end

    private

    def parent_directory(lang = :ja)
      "#{lang}/articles/"
    end
  end

  def i18n_locale_from_language
    japanese? ? :ja : :en
  end

  def append_tags(tag_names)
    tag_names ||= []
    delete_tag_ids = will_delete_tag_ids tag_names
    article_tags.where(tag_id: delete_tag_ids).destroy_all
    tag_names.each { |tag_name| append_tag tag_name }
  end

  def recommend_articles
    Article
      .joins(:tags)
      .where(tags: tags)
      .where.not(id: id)
      .order(published_at: :desc)
      .distinct
      .limit(MAX_RECOMMEND_ARTICLES_COUNT)
  end

  def published_at
    read_attribute(:published_at).presence || updated_at
  end

  def s3_path
    self.class.s3_path code, lang: i18n_locale_from_language
  end

  def front_content_path
    self.class.front_content_path code, lang: i18n_locale_from_language
  end

  def delete_s3_content_after_update?
    state_previous_changes = previous_changes['state']
    return if state_previous_changes.blank?

    state_previous_changes[0] == 'opened' && state_previous_changes[1] == 'closed'
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

  def insert_published_at
    return if read_attribute(:published_at).present?
    return if closed?

    self.published_at = Time.zone.now
  end
end
