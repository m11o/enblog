# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  title        :string(255)      not null
#  description  :text(65535)
#  body         :text(16777215)   not null
#  language     :integer          default(0), not null
#  state        :integer          default(0), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Article < ApplicationRecord
end
