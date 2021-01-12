class HomeController < ApplicationController

  def trending
    @trending_tags = Tagging.trending_tags_with_count
    @trending_users = User.includes(:blogs).first(5)
    @blogs = Blog.trending_blogs.page(params[:page]).per(12)
  end

  def search
    @tags = Tag.__elasticsearch__.search(
      {
        query: {
          query_string: {
            query: "*#{params[:q]}*",
            fields: ['name', 'slug']
          }
        },
      }
    )
    # @categories = Category.__elasticsearch__.search(
    #   {
    #     query: {
    #       query_string: {
    #         query: "*#{params[:q]}*",
    #         fields: ['name', 'slug']
    #       }
    #     },
    #   }
    # )
    @articles = Blog.__elasticsearch__.search(
      {
        query: {
          query_string: {
            query: "*#{params[:q]}*",
            fields: ['title^10', 'description', 'slug']
          }
        },
      }
    )
    @users = User.__elasticsearch__.search(
      {
        query: {
          query_string: {
            query: "*#{params[:q]}*",
            fields: ['name', 'username']
          }
        },
      }
    )

    respond_to do |format|
      format.html {}
      format.json {
        @tags = @tags.limit(5)
        # @categories = @categories.limit(5)
        @articles = @articles.limit(5)
        @users = @users.limit(5)
      }
    end
  end

end