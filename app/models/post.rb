class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author, class_name: "User"

  def self.hot_posts_lazy
     posts = Post.where("view_count>10")
     return posts
  end

  def self.hot_posts_eager
     posts = Post.includes([
        :author => :address, 
        :comments => {:user => :address}
      ]).where("view_count>10")
     return posts
  end

  def comments_from_same_country
    comments.select { |comment| comment.user.address.country == author.address.country }
  end

  def self.same_country_comments_of_hot_posts method
    rs = []
    hot_posts = self.send('hot_posts_'+method)
    hot_posts.each {|p| rs.concat p.comments_from_same_country }
    return rs
  end
end
