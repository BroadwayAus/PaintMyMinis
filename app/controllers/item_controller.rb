class ItemController < ApplicationController
  def page
    @items = Listing.all
  end
end
