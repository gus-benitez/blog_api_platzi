class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  def author
    user = self.object.user
    {
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
