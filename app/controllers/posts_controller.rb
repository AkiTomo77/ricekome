class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
    def index
        @posts = Post.all
        if params[:search] == nil
          @posts= Post.all
        elsif params[:search] == ''
          @posts= Post.all
        else
          @posts = Post.where("rice_name LIKE ? ",'%' + params[:search] + '%')
        end
        if params[:tag_ids]
          @posts = []
          params[:tag_ids].each do |key, value|      
            @posts += Tag.find_by(name: key).posts if value == "1"
          end
          @posts.uniq!
        end
          if params[:tag]
            Tag.create(name: params[:tag])
          end
          @all_ranks = Post.find(Like.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    end

    def new
        @post = Post.new
    end
    
    def create
      post = Post.new(post_params)
      post.user_id = current_user.id 
        if  post.save
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
    end
     
    def show
     
          @post = Post.find(params[:id])
          @comments = @post.comments
          @comment = Comment.new 
    end  
    def edit
      @post = Post.find(params[:id])
    end

    def update
      post = Post.find(params[:id])
      if post.update(post_params)
        redirect_to :action => "show", :id => post.id
      else
        redirect_to :action => "new"
      end
    end

    def destroy
      post = Post.find(params[:id])
      post.destroy
      redirect_to action: :index
    end
    
      private
      def  post_params
        params.require(:post).permit(:rice_name, :rice_from, :rice_flavor, :about, tag_ids: [])
      end
end
