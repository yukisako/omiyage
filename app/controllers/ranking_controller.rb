class RankingController < ApplicationController
  def have_list
    @top_have_items_id = Ownership.where(type: "Have").group(:item_id).order('count_item_id desc').count('item_id').keys   #ハッシュのキーを集めて配列にする。
    @top_have_items = Item.find(@top_have_items_id)
  end

  def want_list
    @top_want_items_id = Ownership.where(type: "Want").group(:item_id).order('count_item_id desc').count(:item_id).keys
    @top_want_items = Item.find(@top_want_items_id)
  end
end
