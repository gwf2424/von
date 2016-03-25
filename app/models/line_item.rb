class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  #LineItem.price
  def total_price
  	price * quantity
  end
end
