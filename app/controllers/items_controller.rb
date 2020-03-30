class ItemsController < ApplicationController
before_action :authenticate_user!, except: [:index, :showAll, :showOne, :show, :index, :index2, :index3]


  def index
    @q = params[:q]
    @items = Item.search((params[:q].present? ? params[:q] : '*')).records
        @menu_topics = Topic.all.order(title: :asc)
        @activ_topics = []
        Group.all.each do |group|
            @activ_topics.push(group.topic_id)
        end
        @menu_topics = @menu_topics.where(id: @activ_topics)
        @menu_topics_yes = 1
  end

  def index2
    @tag = Tag.find(params[:tag_id])
    @itemTag = ItemTag.where(tag_id: @tag.id)
    @allItems = []
              i = 0
              @itemTag.each do |tag|
                @allItems[i] = tag.item_id
                i = i + 1
              end
    @items = Item.where(id: @allItems)
    @menu_topics = Topic.all.order(title: :asc)
    @activ_topics = []
    Group.all.each do |group|
        @activ_topics.push(group.topic_id)
    end
    @menu_topics = @menu_topics.where(id: @activ_topics)
    @menu_topics_yes = 1

  end

    def index3
      @topic = Topic.find(params[:topic_id])
      @groups = Group.where(topic_id: @topic.id)
      @topics = Topic.all
      m = 0
        @groups.each do |tag|
          if @groups[m].title.length > 40
              @groups[m].title = @groups[m].title.slice(0..40) + "..."
          end
          @groups[m].description = @groups[m].description.slice(0..150) + "..."
          m = m + 1
        end
            @menu_topics = Topic.all.order(title: :asc)
            @activ_topics = []
            Group.all.each do |group|
                @activ_topics.push(group.topic_id)
            end
            @menu_topics = @menu_topics.where(id: @activ_topics)
            @menu_topics_yes = 1
    end

  def create
    @item = Item.new(item_params)
    @group = Group.find(params[:group_id])
    @group.items_count = @group.items_count + 1
    @item.group_id = @group.id
    if @item.save
        @group.save
        @tag = params[:tags]
        @tag.each do |value|
            if @new_tag = Tag.find_by(title: value)
                @itemTag = ItemTag.new()
                @itemTag.tag_id =  @new_tag.id
                @itemTag.item_id =  @item.id
                @itemTag.save
            else
                @newTag = Tag.new(title: value)
                @newTag.save
                @itemTag = ItemTag.new()
                @itemTag.tag_id =  @newTag.id
                @itemTag.item_id =  @item.id
                @itemTag.save

            end
        end
        redirect_to showAll_item_path(:group_id => @group.id)
    else
    flash.now[:alert] =  'Please, fill in all fields.'
    render :new
    end
  end

  def new
          @group = Group.find(params[:group_id])
          @tags = Tag.all.order(title: :asc)
          @allTags = []
          i = 0
          @tags.each do |tag|
            @allTags[i] = tag.title
            i = i + 1
          end
  end

  def showAll
          @group = Group.find(params[:group_id])
          @item = Item.where(group_id: params[:group_id])
          @user = User.find(@group.user_id)
    @menu_topics = Topic.all.order(title: :asc)
    @activ_topics = []
    Group.all.each do |group|
        @activ_topics.push(group.topic_id)
    end
    @menu_topics = @menu_topics.where(id: @activ_topics)
    @menu_topics_yes = 1
  end

  def showOne
          @item = Item.find(params[:id])
          @group = Group.find(params[:group_id])
              @menu_topics = Topic.all.order(title: :asc)
              @activ_topics = []
              Group.all.each do |group|
                  @activ_topics.push(group.topic_id)
              end
              @menu_topics = @menu_topics.where(id: @activ_topics)
              @menu_topics_yes = 1
  end

    def show
            @comment = Comment.where(item_id: params[:id]).where("comments.id > ?", params[:max_id]) .order(created_at: :asc).joins(:user).select('comments.id, comments.item_id, users.name as name, comments.body as body, comments.created_at as created_at')
            render json: @comment
    end

    def likes
                @user = User.find(params[:user_id])
                @item = Item.find(params[:item_id])
                if (Like.find_by(user_id: @user.id, item_id: @item.id))
                     @like = Like.find_by(user_id: @user.id, item_id: @item.id)
                     @like.destroy
                     render json: {"vote"=>"nothing"}
                else
                     @like = Like.new(user_id: @user.id, item_id: @item.id)
                     @like.save
                     render json: @like
                end

    end

    def loadingLikes
                @user = User.find(params[:user_id])
                @item = Item.find(params[:item_id])
                if (Like.find_by(user_id: @user.id, item_id: @item.id))
                     @like = Like.find_by(user_id: @user.id, item_id: @item.id)
                     render json: @like
                else
                     render json: {"vote"=>"nothing"}
                end
    end

  def edit
          @group = Group.find(params[:group_id])
          @item = Item.find(params[:id])
          @tags = Tag.all.order(title: :asc)
          @itemTag = ItemTag.all.where(item_id: @item.id)
          @myTags = []
          i = 0
          @itemTag.each do |itemTag|
              @myTag = Tag.find(itemTag.tag_id)
              @myTags[i] = @myTag.title
              i = i + 1
          end
          @allTags = []
          m = 0
          @tags.each do |tag|
              @allTags[m] = tag.title
              m = m + 1
          end
  end

  def update
    @item = Item.find(params[:id])
    @group = Group.find(params[:group_id])
    if @item.update(item_params)
        @itemTag = ItemTag.all.where(item_id: @item.id)
        @itemTag.each do |itemTag|
            itemTag.destroy
        end
        @tag = params[:tags]
        @tag.each do |value|
            if !value.blank?
                if @new_tag = Tag.find_by(title: value)
                    @itemTag = ItemTag.new(tag_id:  @new_tag.id, item_id:  @item.id)
                    @itemTag.save
                else
                    @newTag = Tag.new(title: value)
                    @newTag.save
                    @itemTag = ItemTag.new(tag_id: @newTag.id, item_id:  @item.id)
                    @itemTag.save
                end
            end
        end
        redirect_to showAll_item_path(:group_id => @group.id)
    else
        flash.now[:alert] =  'Sorry, an unexpected error.'
        render :edit
    end
  end

  def destroy
      @item = Item.find(params[:id])
      @group = Group.find(params[:group_id])
      @group.items_count = @group.items_count - 1
      @group.save
      @item.destroy
      redirect_to showAll_item_path(:group_id => @group.id)
  end

  private
    def item_params
      params.require(:item).permit(:title, :text)
    end

end
