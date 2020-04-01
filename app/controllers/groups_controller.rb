class GroupsController < ApplicationController
before_action :authenticate_user!, except: [:showAll]


    def upload
        if @previous_group = Group.where(topic_id: 1, description: 'description', title: 'title', user_id: params[:id]).first
            @previous_group.destroy
        end
        @group = Group.new(upload_params)
        @group.user_id=params[:id]
        @group.topic_id=1
        @group.description='description'
        @group.title='title'
        @group.save
    end

    def upload_params
        params.require(:group).permit(:image)
    end

  def create
    @user = User.find(params[:user_id])
    if @group = Group.where(topic_id: 1, description: 'description', title: 'title', user_id: params[:user_id]).first
        @group.update(create_params)
        @topic = Topic.find_by(title: params[:title])
        @group.update(:topic_id => @topic.id)
    else
        @group2 = Group.new(create_params)
        @topic = Topic.find_by(title: params[:title])
        @group2.topic_id = @topic.id
        @group2.user_id = @user.id
        @group2.image.attach(io: File.open(Rails.root.to_s  + '/app/assets/images/1534181477.jpg'), filename: '1534181477.jpg')
        @group2.save!
    end
    redirect_to user_root_path(:id => @user.id)
  end

  def new
          @user = User.find(params[:user_id])
          @userID = @user.id
          @topics = Topic.all.order(title: :asc)
          @users = User.all
          @group = Group.all

  end

  def showAll
          @user = User.find(params[:id])
          @groups = Group.find_by(user_id: params[:id])
          @topics = Topic.all.order(title: :asc)
          if @previous_group = Group.where(topic_id: 1, description: 'description', title: 'title').first
              @previous_group.destroy
          end
    @menu_topics = Topic.all.order(title: :asc)
    @activ_topics = []
    Group.all.each do |group|
        @activ_topics.push(group.topic_id)
    end
    @menu_topics = @menu_topics.where(id: @activ_topics)
    @menu_topics_yes = 1


  end

  def edit
          @user = User.find(params[:user_id])
          @userID = @user.id
          @group = Group.find(params[:id])
          @topics = Topic.all.order(title: :asc)
          @groups = Group.all
          @mytopic = Topic.find(@group.topic_id).title
  end

  def update
    @user = User.find(params[:user_id])
    if @new = Group.where(topic_id: 1, description: 'description', title: 'title', user_id: params[:user_id]).first
        @topic = Topic.find_by(title: params[:title])
        @new_attachment = ActiveStorage::Attachment.find(@new.image.id)
        new_record_id = @new_attachment.record_id
        new_blob_id = @new_attachment.blob_id
                @group = Group.find(params[:id])
                @group_attachment = ActiveStorage::Attachment.find(@group.image.id)
                last_blob_id = @group_attachment.blob_id
                last_record_id = @group_attachment.record_id
                @new_attachment.record_id = last_record_id
                @group_attachment.record_id = new_record_id
                @group_attachment.blob_id = new_blob_id
                @new_attachment.save
                @group_attachment.save
                @group.update(create_params)
                @topic = Topic.find_by(title: params[:title])
                @group.update(:topic_id => @topic.id)
                @group.save
                ActiveStorage::Blob.find(last_blob_id).destroy
                redirect_to user_root_path(:id => @group.user_id)
    else
    @group = Group.find(params[:id])
    @group.update(create_params)
    @topic = Topic.find_by(title: params[:title])
    @group.update(:topic_id => @topic.id)
    redirect_to user_root_path(:id => @group.user_id)
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to user_root_path(:id => @group.user_id)
  end

    def create_params
          params.require(:group).permit(:description, :title, :file)
    end

end
