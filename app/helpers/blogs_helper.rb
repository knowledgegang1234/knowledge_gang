module BlogsHelper
  def get_categories
    @categories_list ||= Category.order(name: :asc).collect{ |category| [category.name, category.id]}
  end

  def get_countries
    Country.order(name: :asc).collect{ |country| [country.name, country.id]}
  end
end