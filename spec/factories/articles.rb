FactoryBot.define do
  factory :article do
    title { Faker::App.name }
    description { Faker::Markdown.headers }
    body { Faker::Markdown.block_code }
  end
end
