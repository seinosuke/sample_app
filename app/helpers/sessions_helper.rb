module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    # permanentメソッドによって自動的に期限が20.years.from_nowに設定
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # コントローラからもビューからもアクセスできるcurrent_userを作成する
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  # データベース上の記憶トークンは暗号化されているので、
  # cookiesから取り出した記憶トークンは、検索する前に暗号化する必要がある
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
