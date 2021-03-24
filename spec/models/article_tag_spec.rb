# == Schema Information
#
# Table name: article_tags
#
#  id         :bigint           not null, primary key
#  article_id :integer          not null
#  tag_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe ArticleTag, type: :model do
end
