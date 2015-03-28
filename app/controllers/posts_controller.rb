class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.where('remote = ?', '').order("date DESC").paginate(:page => params[:page], :per_page => 20)
    @posts_remote = Post.where('remote = ?', 'y').order("date DESC")
  end

end
