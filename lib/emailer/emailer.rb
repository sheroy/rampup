class Emailer < ActionMailer::Base
  def notify(recipient, user_profile, sent_at = Time.now)
    @subject = '[RampUp] ' + user_profile.common_name + ' has modified his/her profile.'
    @recipients = recipient
    @from = 'no-reply@thoughtworks.com'
    @sent_on = sent_at
    @body["user_profile"] = user_profile
    @headers = {}
    @content_type = 'text/html'
  end
end
