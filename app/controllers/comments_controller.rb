class CommentsController < ApplicationController

  def create
    @item = Item.find(params[:item_id])
    @group = Group.find(@item.group_id)
    @comment = @item.comments.create(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
        redirect_to showOne_item_path(:id => @item.id, :group_id => @group.id)
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

end
