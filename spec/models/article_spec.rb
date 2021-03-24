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
    subject { Article.s3_path code, lang: lang }

    let(:code) { 'hoge123' }

    context 'when lang is ja' do
      let(:lang) { :ja }

      it { is_expected.to eq 'ja/articles/hoge123.html' }
    end

    context 'when lang is en' do
      let(:lang) { :en }

      it { is_expected.to eq 'en/articles/hoge123.html' }
    end
  end

  describe '#self.front_content_path' do
    subject { Article.front_content_path code, lang: lang }

    let(:code) { 'hoge123' }

    context 'when lang is ja' do
      let(:lang) { :ja }

      it { is_expected.to eq '/ja/articles/hoge123' }
    end

    context 'when lang is en' do
      let(:lang) { :en }

      it { is_expected.to eq '/en/articles/hoge123' }
    end
  end

  describe '#s3_path' do
    subject { article.s3_path }

    let(:article) { build(:article, code: 'A123456789', language: language) }

    context 'when language is japanese' do
      let(:language) { :japanese }

      it { is_expected.to eq 'ja/articles/A123456789.html' }
    end

    context 'when language is english' do
      let(:language) { :english }

      it { is_expected.to eq 'en/articles/A123456789.html' }
    end
  end

  describe '#front_content_path' do
    subject { article.front_content_path }

    let(:article) { build(:article, code: 'A123456789', language: language) }

    context 'when language is japanese' do
      let(:language) { :japanese }

      it { is_expected.to eq '/ja/articles/A123456789' }
    end

    context 'when language is english' do
      let(:language) { :english }

      it { is_expected.to eq '/en/articles/A123456789' }
    end
  end

  describe '#recommend_articles' do
    subject(:result) { article.recommend_articles }

    let(:tag1) { create(:tag, name: 'タグ1') }
    let(:tag2) { create(:tag, name: 'タグ2') }

    let(:article) { create(:article, tags: tags, language: language) }

    let!(:ja_article1) { create(:article, title: '記事ja_1', language: :japanese, tags: [tag1]) }
    let!(:ja_article2) { create(:article, title: '記事ja_2', language: :japanese, tags: [tag2]) }
    let!(:ja_article3) { create(:article, title: '記事ja_3', language: :japanese, tags: [tag1, tag2]) }

    let!(:en_article1) { create(:article, title: '記事en_1', language: :english, tags: [tag1]) }
    let!(:en_article2) { create(:article, title: '記事en_2', language: :english, tags: [tag2]) }
    let!(:en_article3) { create(:article, title: '記事en_3', language: :english, tags: [tag1, tag2]) }

    context 'when language is japanese' do
      let(:language) { :japanese }

      context 'with tag1' do
        let(:tags) { [tag1] }

        it 'return 2 articles' do
          expect(result.count).to eq 2
        end

        it 'except myself' do
          expect(result).not_to include article
        end

        it 'confirm article titles' do
          expect(result).to match_array [ja_article1, ja_article3]
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
          expect(result).to match_array [ja_article2, ja_article3]
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
          expect(result).to match_array [ja_article1, ja_article2, ja_article3]
        end
      end
    end

    context 'when language is english' do
      let(:language) { :english }

      context 'with tag1' do
        let(:tags) { [tag1] }

        it 'return 2 articles' do
          expect(result.count).to eq 2
        end

        it 'except myself' do
          expect(result).not_to include article
        end

        it 'confirm article titles' do
          expect(result).to match_array [en_article1, en_article3]
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
          expect(result).to match_array [en_article2, en_article3]
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
          expect(result).to match_array [en_article1, en_article2, en_article3]
        end
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

  describe '#i18n_locale_from_language' do
    subject { article.i18n_locale_from_language }

    let(:article) { build(:article, language: language) }

    context 'when language is japanese' do
      let(:language) { :japanese }

      it { is_expected.to eq :ja }
    end

    context 'when language is english' do
      let(:language) { :english }

      it { is_expected.to eq :en }
    end
  end
end
