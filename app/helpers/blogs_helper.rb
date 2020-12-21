module BlogsHelper
  def get_categories
    @categories_list ||= Category.order(name: :asc).collect{ |category| [category.name, category.id]}
  end
end