class User < ActiveRecord::Base
  before_save { self.email.downcase! }
  # create_remember_tokenというメソッドを探し、ユーザーを保存する前に実行する
  before_create :create_remember_token

  validates :name, presence: true,
                   length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    # A–Z、a–z、0–9、“-”、“_”のいずれかの文字 (64種類) からなる長さ16のランダムな文字列を返します
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    # to_sメソッドを呼び出しているのは、nilトークンを扱えるようにするため
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
