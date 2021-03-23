module Articles
  class PreviewsController < ApplicationController
    include ::FrontBaseHelper

    layout 'blog'

    before_action :set_preview
    before_action :set_articles, only: :index

    def index
      render 'blog/index'
    end

    def show
      load_article params[:code]
      render 'blog/show'
    end

    private

    def set_preview
      @preview = true
    end
  end
end
