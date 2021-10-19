class PostReportJob < ApplicationJob
  queue_as :default # Usado cuando se usa aplicaciones externas para manejar colas, ejemplo Redis

  def perform(_user_id, post_id)
    post = Post.find(post_id)
    report = PostReport.generate(post)
  end
end
