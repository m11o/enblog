module FrontBaseHelper
  MAX_ARTICLE_LIST_COUNT = 25

  def set_articles
    @articles = Article.includes(:tags).order(published_at: :desc, id: :desc).limit(MAX_ARTICLE_LIST_COUNT)
  end

  def load_article(code)
    @article = Article.find_by! code: code
    @related_articles = @article.recommend_articles
  end
end
