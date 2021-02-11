class UsersController < ApplicationController

  def show
    #uset_idから特定のレコードを取得
    @user = User.find(params[:id])
  end

end
