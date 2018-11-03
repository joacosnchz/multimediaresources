class StatesController < ApplicationController
  before_filter :set_state, only: [:show, :edit, :update, :destroy]
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
    @states = State.paginate(:page => params[:page])
    respond_with(@states)
  end

  def show
    respond_with(@state)
  end

  def new
    @state = State.new
    @countries = Country.select('id, name').order('name asc')
    @selected_country = @countries.first
    @selected_state = @selected_country.states.first
    
    respond_with(@state)
  end

  def edit
    @countries = Country.select('id, name').order('name asc')
    @selected_country = @state.country
  end

  def create
    @state = State.new(params[:state])
    @state.save
    respond_with(@state)
  end

  def update
    @state.update_attributes(params[:state])
    respond_with(@state)
  end

  def destroy
    @state.destroy
    respond_with(@state)
  end
  
  def get_cities
    state_id = params[:id]
    state = State.find(state_id)
    @cities = state.cities.select('id, name').order('name asc')
    
    return render json: @cities
  end

  private
    def set_state
      @state = State.find(params[:id])
    end
end
