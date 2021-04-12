class PostsController < ApplicationController
  # include ActionView::Helpers::TextHelper

  skip_before_action :authenticate_user!, :only => [:index, :top, :fresh]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like]

  def index
    redirect_to fresh_posts_path
  end

  def top
    @posts = Post.all.order(cached_votes_score: :desc)
    render 'index'
  end

  def fresh
    @posts = Post.all.order(created_at: :desc)
    render 'index'
  end

  def show
  end

  def like
    if current_user.voted_up_on? @post
      @post.downvote_by current_user
    elsif current_user.voted_down_on? @post
      @post.upvote_by current_user
    else
      @post.upvote_by current_user
    end
    respond_to do |format|
     format.js
    end
  end

  def new
    @post = Post.new
  end

  def edit
    if @post.user = current_user
    else
      redirect_to root_path, notice: 'У вас нет прав!'
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Пост был успешно создан.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @post.user = current_user
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Пост был успешно обновлен.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: 'У вас нет прав!'
    end
  end

  def destroy
    if @post.user = current_user
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Пост был успешно удален.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: 'У вас нет прав!'
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content)
    end
end
