class Listing < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  before_save :remove_whitespace


  
  
  
  private
  # ensures no unnecessary white spaces are allowed through to the database
  def remove_whitespace
    self.name = self.name.strip
    self.description = self.description.strip
  end

  # def is_integer
  #   if self.price.class != Integer || self.price.class != Float
  #     redirect_to root_path
  #     alert("Please enter a vaild price.")
  #   end
  # end

end
