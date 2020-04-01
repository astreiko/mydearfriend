class PersonsController < ApplicationController
before_action :authenticate_user!
before_action :authenticate_admin!

  def authenticate_admin!
    # check if current user is admin
    unless current_user.admin
      # if current_user is not admin redirect to some route
      redirect_to root_path
    end
    # if current_user is admin he will proceed to edit action
  end

  def management
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

end
