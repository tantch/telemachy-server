class UserController < ApplicationController
  before_action :authenticate_user!
  def me
    render :json => current_user[:email]
  end

end
