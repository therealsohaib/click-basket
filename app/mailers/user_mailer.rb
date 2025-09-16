class UserMailer < ApplicationMailer
  default from: 'no-reply@qq.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to ClickBasket')
  end
end
