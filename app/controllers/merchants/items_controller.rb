class Merchants::ItemsController < ApplicationController
  include OrderableByTimestamp

  def index

    @items = Item.all.by_earliest_created.limit(20)

    @merchant = Merchant.find(params[:id])

  end
end
