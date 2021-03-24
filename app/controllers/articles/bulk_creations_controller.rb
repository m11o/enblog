module Articles
  class BulkCreationsController < ApplicationController
    include FrontBaseHelper

    def create
      generate_article_list :ja
      generate_article_list :en

      Article.opened.pluck(:code).each do |code|
        generate_article_content code
      end

      Aws::PurgeCacheService.call! '/*'
    end
  end
end
