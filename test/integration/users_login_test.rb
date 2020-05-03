require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

def setup
  @user = users(:michael)
end

#usersはixtureのファイル名users.ymlを表し、:michaelというシンボルはfixtureのユーザーの内容を参照するためのキー



  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end


test "login with valid information" do
  get login_path
  post login_path, params: { session: { email:    @user.email,
                                        password: 'password' } }
  assert_redirected_to @user
  follow_redirect!
  assert_template 'users/show'
  assert_select "a[href=?]", login_path, count: 0
  assert_select "a[href=?]", logout_path
  assert_select "a[href=?]", user_path(@user)
end

# ログイン用のパスを開く
# セッション用パスに有効な情報をpostする
# ログイン用リンクが表示されなくなったことを確認する
    # count: 0というオプションをassert_selectに追加すると、渡したパターンに一致するリンクが０かどうかを確認
# ログアウト用リンクが表示されていることを確認する
# プロフィール用リンクが表示されていることを確認する

test "login with valid information followed by logout" do
  get login_path
  post login_path, params: { session: { email:    @user.email,
                                        password: 'password' } }
  assert is_logged_in?
  assert_redirected_to @user
  follow_redirect!
  assert_template 'users/show'
  assert_select "a[href=?]", login_path, count: 0
  assert_select "a[href=?]", logout_path
  assert_select "a[href=?]", user_path(@user)
  delete logout_path
  assert_not is_logged_in?
  assert_redirected_to root_url
  follow_redirect!
  assert_select "a[href=?]", login_path
  assert_select "a[href=?]", logout_path,      count: 0
  assert_select "a[href=?]", user_path(@user), count: 0
end
end