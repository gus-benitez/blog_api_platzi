class PostsController < ApplicationController
  # "!" added by convention, when an action can modify the behavior of the request
  before_action :authenticate_user!, only: %i[create update]

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

  def authenticate_user!
    # Bearer xxxxxx
    token_regex = /Bearer (\w+)/
    # Leer HEADER de auth
    headers = request.headers
    # Verificar que sea valido
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      # Verificar que el token corresponda a un user
      return if (Current.user = User.find_by_auth_token(token))
    end

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
