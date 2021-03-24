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
require 'rails_helper'

describe Article, type: :model do
  describe '#self.s3_path' do
    subject { Article.s3_path code }

    let(:code) { 'hoge123' }

    it { is_expected.to eq 'articles/hoge123.html' }
  end

  describe '#self.front_content_path' do
    subject { Article.front_content_path code }

    let(:code) { 'hoge123' }

    it { is_expected.to eq '/articles/hoge123' }
  end

  describe '#s3_path' do
    subject { article.s3_path }

    let(:article) { build(:article, code: 'A123456789') }

    it { is_expected.to eq 'articles/A123456789.html' }
  end

  describe '#front_content_path' do
    subject { article.front_content_path }

    let(:article) { build(:article, code: 'A123456789') }

    it { is_expected.to eq '/articles/A123456789' }
  end

  describe '#recommend_articles' do
    subject(:result) { article.recommend_articles }

    let(:tag1) { create(:tag, name: 'タグ1') }
    let(:tag2) { create(:tag, name: 'タグ2') }

    let(:article) { create(:article, tags: tags) }

    let!(:other_article1) { create(:article, title: '記事1', tags: [tag1]) }
    let!(:other_article2) { create(:article, title: '記事2', tags: [tag2]) }
    let!(:other_article3) { create(:article, title: '記事3', tags: [tag1, tag2]) }

    context 'with tag1' do
      let(:tags) { [tag1] }

      it 'return 2 articles' do
        expect(result.count).to eq 2
      end

      it 'except myself' do
        expect(result).not_to include article
      end

      it 'confirm article titles' do
        expect(result).to match_array [other_article1, other_article3]
      end
    end

    context 'with tag2' do
      let(:tags) { [tag2] }

      it 'return 2 articles' do
        expect(result.count).to eq 2
      end

      it 'except myself' do
        expect(result).not_to include article
      end

      it 'confirm article titles' do
        expect(result).to match_array [other_article2, other_article3]
      end
    end

    context 'with tag1 and tag2' do
      let(:tags) { [tag1, tag2] }

      it 'return 3 articles' do
        expect(result.count).to eq 3
      end

      it 'except myself' do
        expect(result).not_to include article
      end

      it 'confirm article titles' do
        expect(result).to match_array [other_article1, other_article2, other_article3]
      end
    end
  end

  describe '#delete_s3_content_after_update?' do
    subject { article.delete_s3_content_after_update? }

    let(:article) { create(:article, state: state) }

    context 'when altering from closed to opened' do
      let(:state) { :closed }

      before { article.opened! }

      it { is_expected.to be_falsey }
    end

    context 'when altering from opened to closed' do
      let(:state) { :opened }

      before { article.closed! }

      it { is_expected.to be_truthy }
    end

    context 'with non-changing' do
      let(:state) { :opened }

      before { article.update title: 'hogeほげ' }

      it { is_expected.to be_falsey }
    end
  end
end
