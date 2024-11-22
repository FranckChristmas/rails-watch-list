class ListsController < ApplicationController
  def index
    @lists = List.all
  end
  def show
    @list = List.find(params[:id])
  end
  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to lists_path
    else
    render :new, status: :unprocessable_entity
    end
  end
end

private

def list_params
  params.require(:list).permit(:name)
end


# So, the goal is to add a user-uploaded picture to the List model, so that each list will be better illustrated.
# The user should be able to upload an image that will then be displayed on the
# index view of List as a thumbnail/cover. On the #show view of a List, the same image should be displayed, but bigger,
# followed by the movies that have been saved to it!
