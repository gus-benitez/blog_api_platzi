class PostReportJob < ApplicationJob
  queue_as :default # Usado cuando se usa aplicaciones externas para manejar colas, ejemplo Redis

  def perform(user_id, post_id)
    user = User.find(user_id)
    post = Post.find(post_id)
    report = PostReport.generate(post)
    # Send email
    PostReportMailer.post_report(user, post, report).deliver_now
    # .deliver_later, send the email in Background
  end
end
