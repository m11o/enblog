class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.includes(:tags).order(updated_at: :desc)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params
    if @article.save
      redirect_to article_path(@article), notice: '保存に成功しました'
    else
      flash.now[:alert] = '保存に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    if @article.update article_params
      redirect_to article_path(@article), notice: '更新に成功しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "#{@article.title}を削除しました"
  end

  private

  def set_article
    @article = Article.find params[:id]
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, :language, :state)
  end
end
