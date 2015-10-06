class RecommendListController < ApplicationController
  def recommend
    if params[:q]
      response1 = Amazon::Ecs.item_search(params[:q]+" お土産" , 
                                  :search_index => 'All' , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp',
                                  :ItemPage => '1')
      response2 = Amazon::Ecs.item_search(params[:q]+" お土産" , 
                                  :search_index => 'All' , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp',
                                  :ItemPage => '2')

      @amazon_items = response1.items + response2.items
      puts @amazon_items
    end
  end
end
