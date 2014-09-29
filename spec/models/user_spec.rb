require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  # name属性とemail属性の存在をテストします。
  # respond_to?メソッドは、シンボルを1つ引数として受け取り、
  # そのシンボルが表すメソッドまたは属性に対して、
  # オブジェクトが応答する場合はtrueを返し、応答しない場合はfalseを返します。

  # it "should respond to 'name'" do
  #   expect(@user).to respond_to(:name)
  # end

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  # ユーザーのnameに無効な値 (blank) を設定し、@userオブジェクトの結果も無効になることをテスト
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # 無効なメアド
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  # 有効なメアド
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  # 重複するメールアドレスの拒否のテスト
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # メールアドレスを小文字に変換するコードに対するテスト
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    # reloadメソッドを使用してデータベースから値を再度読み込み、eqメソッドを使用して同値であるかどうかをテスト
    # app/models/user.rb の before_save { self.email = email.downcase } を確認
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    # 最初に、ユーザーをメールアドレスで検索します
    let(:found_user) { User.find_by(email: @user.email) }

    # 次に、受け取ったパスワードでユーザーを認証します
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    # パスワードが一致しない場合
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  # itsメソッドはitが指すテストのsubject (ここでは@user) そのものではなく、
  # 引数として与えられたその属性 (ここでは:remember_token) に対してテスト
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

end