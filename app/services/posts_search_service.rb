class PostsSearchService
  def self.search(curr_post, query)
    # Agregar cache para optimizar
    # Funciona como llave valor {k => v}
    posts_ids = Rails.cache.fetch("posts_search/#{query}", expires_in: 1.hours) do
      # We only store the IDs in Cache
      curr_post.where("title like '%#{query}%'").map(&:id)
    end

    # Through the IDs, we look for the publications
    curr_post.where(id: posts_ids)
  end
end
