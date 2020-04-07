class ItemsController < ApplicationController
before_action :authenticate_user!, except: [:index, :showAll, :showOne, :show, :index, :index2, :index3]

    def index
        @q = params[:q]
        @results = []
        if @items = Item.search((params[:q].present? ? params[:q] : '*')).records
            @items.each do |item|
                @results.push(item.id)
            end
        end
        if @groups = Group.search((params[:q].present? ? params[:q] : '*')).records
            @groups.each do |group|
                Item.where(group_id: group.id).each do |item|
                    @results.push(item.id)
                end
            end
        end
        if @comments = Comment.search((params[:q].present? ? params[:q] : '*')).records
            @comments.each do |comment|
                @results.push(comment.item_id)
            end
        end
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
            if @group_apps = GroupApp.where(group_id: @group.id)
                if @params = params[:string]
                    @apps = @group_apps.where(type_data: "String")
                    @params.each_with_index do |string, index|
                        ItemApp.create!(item_id: @item.id, string: string, group_app_id: @apps[index].id)
                    end
                end
                if @params = params[:text]
                    @apps = @group_apps.where(type_data: "Text")
                    @params.each_with_index do |string, index|
                        ItemApp.create!(item_id: @item.id, text: string, group_app_id: @apps[index].id)
                    end
                end
                if @apps = @group_apps.where(type_data: "Boolean")
                    @apps.each_with_index do |app, index|
                        i=0
                        if @params = params[:boolean]
                            @params.each do |param|
                                if param.to_i == app.id
                                    ItemApp.create!(item_id: @item.id, boolean: 1, group_app_id: app.id)
                                    i=1
                                end
                            end
                        end
                        if i==0
                            ItemApp.create!(item_id: @item.id, boolean: 0, group_app_id: app.id)
                        end
                    end
                end
                if @params = params[:date]
                    @apps = @group_apps.where(type_data: "Date")
                    @params.each_with_index do |string, index|
                        ItemApp.create!(item_id: @item.id, date: string, group_app_id: @apps[index].id)
                    end
                end
                if @params = params[:float]
                    @apps = @group_apps.where(type_data: "Float")
                    @params.each_with_index do |string, index|
                        ItemApp.create!(item_id: @item.id, float: string, group_app_id: @apps[index].id)
                    end
                end
            end
            params[:tags].each do |value|
                if @new_tag = Tag.find_by(title: value)
                    @itemTag = ItemTag.create!(tag_id:  @new_tag.id, item_id:  @item.id)
                else
                    unless value.empty?
                        @newTag = Tag.create!(title: value)
                        @itemTag = ItemTag.create!(tag_id:  @newTag.id, item_id:  @item.id)
                    end
                end
            end
            redirect_to showAll_item_path(:group_id => @group.id)
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
        if @group_apps = GroupApp.where(group_id: @group.id)
        end
    end

    def showAll
        @group = Group.find(params[:group_id])
        @item = Item.where(group_id: params[:group_id])
        @item1 = Item.where(group_id: params[:group_id]).first
        @user = User.find(@group.user_id)
        @menu_topics = Topic.all.order(title: :asc)
        @activ_topics = []
        Group.all.each do |group|
            @activ_topics.push(group.topic_id)
        end
        @menu_topics = @menu_topics.where(id: @activ_topics)
        @menu_topics_yes = 1
        @item_apps = ItemApp.where(item_id: Item.where(group_id: @group.id).ids)
        @group_apps = GroupApp.where(group_id: @group.id)
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
        @item_apps = ItemApp.where(item_id: @item.id)
        @group_apps = GroupApp.all
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
        @item_apps = ItemApp.where(item_id: @item.id)
        @group_apps = GroupApp.all
    end

    def update
        @item = Item.find(params[:id])
        @group = Group.find(params[:group_id])
        if @item.update(item_params)
            if @group_apps = GroupApp.where(group_id: @group.id)
                if @params = params[:string]
                    @item_apps = ItemApp.where(item_id: @item.id, group_app_id: @group_apps.where(type_data: "String").ids)
                    @item_apps.each_with_index do |item_app, index|
                        item_app.update(string: @params[index])
                    end
                end
                if @params = params[:text]
                    @item_apps = ItemApp.where(item_id: @item.id, group_app_id: @group_apps.where(type_data: "Text").ids)
                    @item_apps.each_with_index do |item_app, index|
                        item_app.update(text: @params[index])
                    end
                end
                if @params = params[:date]
                    @item_apps = ItemApp.where(item_id: @item.id, group_app_id: @group_apps.where(type_data: "Date").ids)
                    @item_apps.each_with_index do |item_app, index|
                        item_app.update(date: @params[index])
                    end
                end
                if @params = params[:float]
                    @item_apps = ItemApp.where(item_id: @item.id, group_app_id: @group_apps.where(type_data: "Float").ids)
                    @item_apps.each_with_index do |item_app, index|
                        item_app.update(float: @params[index])
                    end
                end
                if @item_apps = ItemApp.where(item_id: @item.id, group_app_id: @group_apps.where(type_data: "Boolean").ids)
                     @item_apps.each_with_index do |item_app, index|
                        i=0
                        if @params = params[:boolean]
                            @params.each do |param|
                                if param.to_i == item_app.group_app_id
                                    item_app.update(boolean: 1)
                                    i=1
                                end
                            end
                        end
                        if i==0
                            item_app.update(boolean: 0)
                        end
                     end
                end
            end
            @itemTag = ItemTag.all.where(item_id: @item.id)
            @itemTag.each do |itemTag|
                itemTag.destroy
            end
            @tag = params[:tags]
            @tag.each do |value|
                unless value.empty?
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
