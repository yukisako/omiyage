class OwnershipsController < ApplicationController
  before_action :logged_in_user

  #アマゾンはASINでアイテムを管理している。
  def create
    if params[:asin]
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合はAmazonのデータを登録する。
    if @item.new_record?
      begin
        # TODO 商品情報の取得 Amazon::Ecs.item_lookupを用いてください
        if params[:asin]
          response = {}
          response = Amazon::Ecs.item_lookup(params[:asin] , 
                              #:search_index => 'All' , 
                              :response_group => 'Medium' , 
                              :country => 'jp')
          @amazon_items = response.items
        end
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      amazon_item       = response.items.first
      @item.title        = amazon_item.get('ItemAttributes/Title')
      @item.small_image  = amazon_item.get("SmallImage/URL")
      @item.medium_image = amazon_item.get("MediumImage/URL")
      @item.large_image  = amazon_item.get("LargeImage/URL")
      @item.detail_page_url = amazon_item.get("DetailPageURL")
      @item.raw_info        = amazon_item.get_hash
      @item.save!
    end

    if params[:type] == "Have"
      current_user.have(@item)
    elsif params[:type] == "Want"
      current_user.want(@item)
    end
  end


  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == "Have"
      current_user.unhave(@item)
    elsif params[:type] == "Want"
      current_user.unwant(@item)
    end
    # TODO 紐付けの解除。 
    # params[:type]の値ににHavedボタンが押された時には「Have」,
    # Wantedボタンがされた時には「Want」が設定されています。
  end

end
