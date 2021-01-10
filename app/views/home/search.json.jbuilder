json.tags do
  json.array!(@tags) do |tag|
    json.name tag.name
    json.type 'tag'
    json.url tag_path(tag.slug)
  end
end

json.categories do
  json.array!(@categories) do |category|
    json.name category.name
    json.type 'category'
    json.url category_path(category.slug)
  end
end

json.articles do
  json.array!(@articles) do |article|
    json.name article.title
    json.type 'blog'
    json.url blog_path(article.slug)
  end
end

json.users do
  json.array!(@users) do |user|
    json.name user.username
    json.type 'user'
    json.url user_path(user.username)
    json.avatar user.avatar || ActionController::Base.helpers.image_url('default_user.png')
  end
end