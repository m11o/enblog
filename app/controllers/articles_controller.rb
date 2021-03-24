class ArticlesController < ApplicationController
  include ::FrontBaseHelper

  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.includes(:tags).order(updated_at: :desc)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    update_attributes = article_params.to_h
    @article = Article.new
    @article.append_tags update_attributes.delete(:tags)
    @article.attributes = update_attributes

    if @article.save
      redirect_to article_path(@article), notice: '保存に成功しました'
    else
      flash.now[:alert] = '保存に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    update_attributes = article_params.to_h
    @article.append_tags update_attributes.delete(:tags)
    if @article.update update_attributes
      delete_s3_content @article if @article.delete_s3_content_after_update?
      redirect_to article_path(@article), notice: '更新に成功しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    delete_s3_content @article if @article.opened?
    @article.destroy

    redirect_to articles_path, notice: "#{@article.title}を削除しました"
  end

  private

  def set_article
    @article = Article.find params[:id]
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, :language, :state, tags: [])
  end

  def delete_s3_content(article)
    Aws::S3DeleteService.call! article.s3_path
    I18n.locale = article.japanese? ? :ja : :en
    generated_list_path = generate_article_list I18n.locale

    Aws::PurgeCacheService.call! article.front_content_path, generated_list_path
  end
end
