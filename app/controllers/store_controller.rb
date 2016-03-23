class StoreController < ApplicationController
	before_action :initialize_count_in_session, only: [:index]

  def index
  	@products = Product.order(:title)
  	counter = session[:store_index_count]
  	counter.nil? ? counter = 1 : counter += 1
  	session[:store_index_count] = counter 
  end

  private
  	def initialize_count_in_session
  		session[:store_index_count] ||= 0
  	end
end
