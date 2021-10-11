module Secured
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
