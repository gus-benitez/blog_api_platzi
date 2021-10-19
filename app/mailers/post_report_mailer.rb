class PostReportMailer < ApplicationMailer
  def post_report(user, post, _post_report)
    @post = post
    mail to: user.email, subject: "Post #{post.id} report"
  end
end
