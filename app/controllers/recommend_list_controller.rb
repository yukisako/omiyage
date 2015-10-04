class RecommendListController < ApplicationController
  def recommend
    if params[:q]
      response = Amazon::Ecs.item_search(params[:q]+" お土産" , 
                                  :search_index => 'All' , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp')
      @amazon_items = response.items
    end
  end
end
