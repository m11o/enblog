module Articles
  class PreviewsController < ApplicationController
    include ::FrontBaseHelper

    layout 'blog'

    before_action :set_preview

    def index
      I18n.locale = params[:lang].presence || I18n.default_locale
      load_articles I18n.locale == :ja ? :japanese : :english

      render 'blog/index'
    end

    def show
      load_article params[:code]
      I18n.locale = @article.i18n_locale_from_language
      render 'blog/show'
    end

    private

    def set_preview
      @preview = true
    end
  end
end
