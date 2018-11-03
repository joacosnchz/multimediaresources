class CitiesController < ApplicationController
  before_filter :set_city, only: [:show, :edit, :update, :destroy]
  before_filter :verify_role_permissions

  respond_to :html
  
  def verify_role_permissions
    role = current_user.roles.first.name
    return true if role == 'admin'
    
    unless ['admin'].include?(role)
      flash[:error] = "Acceso denegado!"
      redirect_to root_url
    end
  end

  def index
     @cities = City.paginate(:page => params[:page])
     respond_with(@cities)
    
#    # @cities = City.all
#    respond_to do|format|
#      format.html
#      format.json { render json: CitiesDatatable.new(view_context) }
#    end
  end

  def show
    respond_with(@city)
  end

  def new
    @city = City.new
    @countries = Country.select('id, name').order('name asc')
    @states = @countries.first.states
    @selected_country = @countries.first
    @selected_state = @selected_country.states.first
    
    respond_with(@city)
  end

  def edit
    @countries = Country.select('id, name').order('name asc')
    @states = @countries.first.states
    @selected_state = @city.state
    @selected_country = @selected_state.country
  end

  def create
    @city = City.new(params[:city])
    @city.save
    respond_with(@city)
  end

  def update
    @city.update_attributes(params[:city])
    respond_with(@city)
  end

  def destroy
    @city.destroy
    respond_with(@city)
  end

  private
    def set_city
      @city = City.find(params[:id])
    end
end
