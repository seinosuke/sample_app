require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com")
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

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

end