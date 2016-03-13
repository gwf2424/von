require 'test_helper'

class ProductTest < ActiveSupport::TestCase

	setup do
		@product = Product.new(
			title: 't1',
			description: 'desc1',
			image_url: '',
			price: 9
			)
	end
	
	test "s b valid" do
		assert @product.valid?
	end

	test "s b PRICE is invalid" do
		@product.price = 0
		assert @product.invalid?
	end

	test "s b " do
		@product.title = ''
		assert @product.invalid?
	end

	test "title is unique!" do
		other_product = Product.new(
			title: products(:one).title,
			description: 'desc2',
			image_url: '',
			price: 8
			)
		assert other_product.invalid?
		assert_equal 'has already been taken', other_product.errors[:title]
	end
end
