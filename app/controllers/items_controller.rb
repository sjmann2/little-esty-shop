class ItemsController < ApplicationController
  include OrderableByTimestamp

  def index
    @items = Item.by_earliest_created.limit(20)
 
    @merchant = Merchant.find(params[:id])
  end
end
