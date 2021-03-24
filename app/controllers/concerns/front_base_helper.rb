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

  def generate_article_list(lang = :ja)
    set_articles

    blog_list_html = render_to_string(template: 'blog/index', layout: 'blog')
    s3_path = lang.to_sym == :ja ? "/ja/#{ARTICLE_LIST_FILENAME}" : ARTICLE_LIST_FILENAME
    Aws::S3UploadService.call! blog_list_html, s3_path

    lang.to_sym == :ja ? '/ja' : '/'
  end

  def generate_article_content(code)
    load_article code
    @article.opened!
    blog_content_html = render_to_string(template: 'blog/show', layout: 'blog')
    Aws::S3UploadService.call! blog_content_html, @article.s3_path

    @article.front_content_path
  end
end
