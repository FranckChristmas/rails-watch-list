class BookmarksController < ApplicationController
  before_action :set_list, only: [ :new, :create ]
  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    if @bookmark.save
      redirect_to lists_path
    else
      render :new, status: :unprocessable_entity
    end
  end
private

def set_list
  @list = List.find(params[:list_id])
end
  def bookmark_params
    @bookmark.require(:bookmark).permit(:comment)
  end
end
