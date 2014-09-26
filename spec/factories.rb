# シンボル:userがfactoryコマンドに渡されると、
# Factory Girlはそれに続く定義がUserモデルオブジェクトを対象としていることを認識します。

FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end