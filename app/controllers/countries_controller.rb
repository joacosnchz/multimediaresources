class CountriesController < ApplicationController
  before_filter :set_country, only: [:show, :edit, :update, :destroy]
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
    @countries = Country.paginate(:page => params[:page])
    respond_with(@countries)
  end

  def show
    respond_with(@country)
  end

  def new
    @country = Country.new
    respond_with(@country)
  end

  def edit
  end

  def create
    @country = Country.new(params[:country])
    @country.save
    respond_with(@country)
  end

  def update
    @country.update_attributes(params[:country])
    respond_with(@country)
  end

  def destroy
    @country.destroy
    respond_with(@country)
  end
  
  def get_states
    country_id = params[:id]
    country = Country.find(country_id)
    @states = country.states.select('id, name').order('name asc')
    
    return render json: @states
  end

  private
    def set_country
      @country = Country.find(params[:id])
    end
end
