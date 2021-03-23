module FrontBaseHelper
  MAX_ARTICLE_LIST_COUNT = 25
  ARTICLE_LIST_FILENAME = 'index.html'.freeze

  private

  def set_articles
    @articles = Article.opened.includes(:tags).order(published_at: :desc, id: :desc).limit(MAX_ARTICLE_LIST_COUNT)
  end

  def load_article(code)
    @article = Article.find_by! code: code
    @related_articles = @article.recommend_articles
  end

  def generate_article_list
    set_articles
    blog_list_html = render_to_string(template: 'blog/index', layout: 'blog')
    Aws::S3UploadService.call! blog_list_html, ARTICLE_LIST_FILENAME
  end

  def generate_article_content(code)
    load_article code
    @article.opened!
    blog_content_html = render_to_string(template: 'blog/show', layout: 'blog')
    Aws::S3UploadService.call! blog_content_html, @article.s3_path
  end
end
