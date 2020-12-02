module BlogsHelper
  def get_categories
    @categories_list ||= Category.all.collect{ |category| [category.name, category.id]}
  end
end