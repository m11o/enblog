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
      generate_article_content params[:code]
      generate_article_list

      Aws::PurgeCacheService.call! Article.front_content_path(params[:code]), '/'
    end
  end
end
