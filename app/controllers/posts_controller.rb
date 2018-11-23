class PostsController < ApplicationController
  before_action :find_group
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :member_required, :only => [:new, :create ]

  def new
    @post = @group.posts.build
  end

  def create
    @post = @group.posts.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = current_user.posts.find(params[:id])

  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to account_posts_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post = Post.find(params[:id])
    @post.destroy
    flash[:alert] = "Group deleted"
    redirect_to account_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def member_required
    if !current_user.is_member_of?(@group)
      flash[:warning] = " You are not member of this group!"
      redirect_to group_path(@group)
    end
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

end
