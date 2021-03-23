module Articles
  class PreviewsController < ApplicationController
    layout 'blog'

    before_action :set_preview

    def index
      @articles = Article.includes(:tags).order(published_at: :desc, id: :desc).limit(25)

      render 'blog/index'
    end

    def show
      @article = Article.find_by! code: params[:code]
      @related_articles = @article.recommend_articles

      render 'blog/show'
    end

    private

    def set_preview
      @preview = true
    end
  end
end
