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
FactoryBot.define do
  factory :article do
    title { Faker::App.name }
    description { Faker::Markdown.headers }
    body { Faker::Markdown.block_code }
  end
end
