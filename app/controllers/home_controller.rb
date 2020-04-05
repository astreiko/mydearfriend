class HomeController < ApplicationController

    def index
    @item = Item.all.order(created_at: :desc).limit(3)
    @menu_topics = Topic.all.order(title: :asc)
    @activ_topics = []
    Group.all.each do |group|
        @activ_topics.push(group.topic_id)
    end
    @menu_topics = @menu_topics.where(id: @activ_topics)
    @menu_topics_yes = 1
    @groups = Group.order(items_count: :desc).limit(6)
    @groups.each do |groups|
        if groups.title.length > 40
            groups.title = groups.title.slice(0..40) + "..."
        end
        groups.description = groups.description.slice(0..150) + "..."
    end

    @itemTag = ItemTag.all
    @allTags = []
          i = 0
          @itemTag.each do |tag|
            @allTags[i] = tag.tag_id
            i = i + 1
          end
    @tags = Tag.where(id: @allTags).order(created_at: :desc).limit(40)
    end

end
