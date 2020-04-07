class TopicsController < ApplicationController
before_action :authenticate_user!, except: [:show]

    def show
        @topics = Topic.all.order(title: :asc)
        @users = User.all
        @groups = Group.all
            @menu_topics = Topic.all.order(title: :asc)
            @activ_topics = []
            Group.all.each do |group|
                @activ_topics.push(group.topic_id)
            end
            @menu_topics = @menu_topics.where(id: @activ_topics)
            @menu_topics_yes = 1
    end

    def create
        @topic = Topic.new(topic_params)
        if @topic.save
            redirect_to topics_show_path
        else
            render 'new'
        end
    end

    private
    def topic_params
        params.require(:topic).permit(:title)
    end

end
