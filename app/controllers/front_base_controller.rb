class FrontBaseController < ApplicationController
  layout 'blog'

  private

  def set_articles
    @articles = Article.includes(:tags).order(published_at: :desc, id: :desc).limit(25)
  end

  def set_article
    @article = Article.find_by! code: params[:code]
    @related_articles = @article.recommend_articles
  end
end
