class ProfilesController < ApplicationController
  before_filter :set_profile, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def edit
    @countries = Country.select('id, name').order('name asc')
    
    if @profile.city.nil?
      @selected_country = @countries.first
      @selected_state = @selected_country.states.first
      @selected_city = @selected_state.cities.first
    else
      @selected_city = @profile.city
      @selected_state = @selected_city.state
      @selected_country = @selected_state.country
    end
    
    @states = @selected_country.states
    @cities = @selected_state.cities
  end

  def update
    if @profile.update_attributes(params[:profile])
      message = 'El perfil fue actualizado correctamente.'
    else
      message = 'Error al actualizar el perfil, por favor intente nuevamente mas tarde.'
    end
    
    redirect_to profile_edit_path, notice: message
  end

  private
    def set_profile
      @profile = current_user.profile
    end
end
