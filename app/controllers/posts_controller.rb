class PostsController < ApplicationController
  rescue_from Exception do |error|
    render json: { error: error.message }, status: :internal_error
  end
  rescue_from ActiveRecord::RecordInvalid do |error|
    render json: { error: error.message }, status: :unprocessable_entity
  end

  # GET /posts
  def index
    posts = Post.where(published: true)
    posts = PostsSearchService.search(posts, params[:search]) if !params[:search].nil? && params[:search].present?
    render json: posts.includes(:user), status: :ok
  end

  # GET /posts/{id}
  def show
    post = Post.find(params[:id])
    render json: post, status: :ok
  end

  # POST /posts
  def create
    post = Post.create!(create_params)
    render json: post, status: :created
  end

  # PUT /posts/{id}
  def update
    post = Post.find(params[:id])
    post.update!(update_params)
    render json: post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
