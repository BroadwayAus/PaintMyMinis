class UserController < ApplicationController
  def page
    @user = current_user
    @items = Listing.all.where(:id => @user)
  end
end
