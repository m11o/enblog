module Articles
  class PublicationsController < ApplicationController
    include ::FrontBaseHelper

    def create
      generate_article_content params[:code]
      generate_article_list

      Aws::PurgeCacheService.call! Article.front_content_path(params[:code]), '/'

      redirect_to articles_path, notice: '記事を公開しました'
    rescue StandardError => e
      Rails.logger.error e
      Rails.logger.error e.backtrace.join("\n")
      redirect_to articles_path, notice: '記事の公開に失敗しました'
    end
  end
end
