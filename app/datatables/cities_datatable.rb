class CitiesDatatable < Datatable


private

  def total_records
    City.count
  end

  def total_entries
    cities.total_entries
  end

  def data
    cities.map do |city|
      [ 
        city.id,
        city.state.country.name,
        city.state.name,
        link_to(city.name, @url_helpers.city_path(city)),
        link_to(I18n.t('.edit', :default => I18n.t("helpers.links.edit")),
                      @url_helpers.edit_city_path(city), :class => 'btn btn-mini').to_s +
        link_to(I18n.t('.destroy', :default => I18n.t("helpers.links.destroy")),
                      @url_helpers.city_path(city),
                      :method => :delete,
                      :data => { :confirm => I18n.t('.confirm', :default => I18n.t("helpers.links.confirm", :default => 'Are you sure?')) },
                      :class => 'btn btn-mini btn-danger').to_s
      ]
    end
  end

  def cities
    @cities ||= fetch_cities
  end

  def fetch_cities
    cities = City.order("#{sort_column} #{sort_direction}")
    cities = cities.page(page).per_page(per_page)
   # if params[:sSearch].present?
     # cities = cities.where("name like :search", search: "%#{params[:sSearch]}%")
   # end
    cities
  end

  def sort_column
    City.datatable_columns[params[:iSortCol_0].to_i]
  end
end    