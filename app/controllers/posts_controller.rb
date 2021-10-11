class PostsController < ApplicationController
  include Secured
  # "!" added by convention, when an action can modify the behavior of the request
  before_action :authenticate_user!, only: %i[create update]

  rescue_from Exception do |error|
    render json: { error: error.message }, status: :internal_error
  end
  rescue_from ActiveRecord::RecordNotFound do |error|
    render json: { error: error.message }, status: :not_found
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
    if post.published? || (Current.user && post.user_id == Current.user.id)
      render json: post, status: :ok
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  # POST /posts
  def create
    post = Current.user.post.create!(create_params)
    render json: post, status: :created
  end

  # PUT /posts/{id}
  def update
    post = Current.user.post.find(params[:id])
    post.update!(update_params)
    render json: post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
