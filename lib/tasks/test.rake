namespace :test do

  desc "populate trivial volumn of data"
  task :populate_trivial => :environment do
    populate_models 10, 100, 0.5
  end

  desc "populate mini volumn of data"
  task :populate_mini => :environment do
    populate_models 100, 1000, 0.5
  end

  desc "populate small volumn of data"
  task :populate_small => :environment do
    populate_models 1000, 10000, 0.5
  end


  desc "populate medium volumn of data"
  task :populate_medium => :environment do
    populate_models 10000, 100000, 0.5
  end

  desc "populate large volumn of data"
  task :populate_large => :environment do
    populate_models 100000, 1000000, 0.5
  end

  desc "clean data"
  task :clean_data => :environment do
    User.destroy_all
    Address.destroy_all
    Post.destroy_all
    Comment.destroy_all
  end

  def populate_models num_users, num_posts, prob_us

    all_users = []

    for i in 1..num_users
      user = User.new({:name=>Faker::Name.name, :pwd=>Faker::Internet.password(8)});
      address = Address.create({
        :street   => Faker::Address.street_address,
        :city     => Faker::Address.city,
        :country  => get_biased_country('United States', prob_us),
        :zip      => Faker::Address.zip_code
        })
      user.address = address
      user.save
      all_users << user
    end

    for i in 1..num_posts
      post = Post.new({:content=>Faker::Lorem.paragraphs(rand(10)+1), :view_count=>rand(num_users*2)})
      post.author = all_users[rand(num_users)]
      for j in 1..rand(num_users)
        comment = Comment.new({:content=>Faker::Lorem.paragraphs(rand(3)+1)})
        comment.user = all_users[rand(num_users)]
        comment.post = post
        comment.save
      end
      post.save
    end

    puts num_users.to_s+" users and "+num_posts.to_s+ " posts has been populated"
  end

  def get_biased_country country, probability
    if rand < probability
      return country
    else
      return Faker::Address.country
    end
  end

end
