module Articles
  class PreviewsController < ::FrontBaseController
    before_action :set_preview
    before_action :set_articles, only: :index
    before_action :set_article, only: :show

    def index
      render 'blog/index'
    end

    def show
      render 'blog/show'
    end

    private

    def set_preview
      @preview = true
    end
  end
end
