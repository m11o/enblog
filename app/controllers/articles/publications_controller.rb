module Articles
  class PublicationsController < ::FrontBaseController
    before_action :set_article, :set_articles

    def create
      @article.opened!

      blog_content_html = render_to_string(template: 'blog/show', layout: 'blog')
      Aws::S3UploadService.call! blog_content_html, @article.upload_s3_path

      blog_list_html = render_to_string(template: 'blog/index', layout: 'blog')
      Aws::S3UploadService.call! blog_list_html, 'index.html'

      Aws::PurgeCacheService.call! @article.front_content_path, '/'
    end
  end
end
