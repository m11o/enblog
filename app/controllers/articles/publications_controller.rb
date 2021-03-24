module Articles
  class PublicationsController < ApplicationController
    include ::FrontBaseHelper

    def create
      publish_content_and_purge!

      redirect_to articles_path, notice: '記事を公開しました'
    rescue StandardError => e
      Rails.logger.error e
      Rails.logger.error e.backtrace.join("\n")
      redirect_to articles_path, notice: '記事の公開に失敗しました'
    end

    private

    def publish_content_and_purge!
      @article = Article.find_by! code: params[:code]

      generated_article_path = generate_article_content params[:code]
      generated_list_path = generate_article_list @article.i18n_locale_from_language

      Aws::PurgeCacheService.call! generated_article_path, generated_list_path
    end
  end
end
