class LineItemsController < ApplicationController
  #set_cart为concern中
  before_action :set_cart, only: [:create, :add_quantity, :minus_quantity]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :add_quantity, :minus_quantity]
  protect_from_forgery except: [:create]

  def delete_this_item

  end

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    #@line_item = @cart.line_items.build(product: product)
    #@line_item = LineItem.new(line_item_params)
    @line_item = @cart.add_product(product.id, product.price)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        ##format.html { redirect_to @line_item.cart }
        #format.html { redirect_to @line_item, notice: 'Line item was successfully created.' }
        format.js { @current_item_id = @line_item.id }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    respond_to do |format|
      #format.html { redirect_to line_items_url, notice: 'Line item was destroyed.' }
      format.html { redirect_to store_url, notice: 'Line item was destroyed.' }
      format.json { head :ok }
    end
  end

  def add_quantity
    #@cart = current_cart
    @line_item = @cart.add_quantity(params[:id])
    #@line_item.update_attributes(quantity: @line_item.quantity + 1)
    #redirect_to store_url #@line_item.cart
    if @line_item.save
      respond_to do |format|
        format.html { redirect_to store_url }
        format.js { @current_item_id = @line_item.id }
      end
    end
  end

  def minus_quantity
    #@cart = current_cart
    @line_item = @cart.minus_quantity(params[:id])
    #redirect_to store_url #@line_item.cart    
    if @line_item.save
      respond_to do |format|
        format.html { redirect_to store_url }
        format.js do
          @current_item_id = @line_item.id
        end
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
  end
