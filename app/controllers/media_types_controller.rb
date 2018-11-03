class MediaTypesController < ApplicationController
  before_filter :set_media_type, only: [:show, :edit, :update, :destroy]
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
    @media_types = MediaType.paginate(:page => params[:page], :per_page => 10).order('name ASC')
    respond_with(@media_types)
  end

  def show
    respond_with(@media_type)
  end

  def new
    @media_type = MediaType.new
    respond_with(@media_type)
  end

  def edit
  end

  def create
    @media_type = MediaType.new(params[:media_type])
    @media_type.save
    flash[:notice] = 'El tipo de medio ha sido creado correctamente.'
    redirect_to action: :index
  end

  def update
    @media_type.update_attributes(params[:media_type])
    flash[:notice] = 'El tipo de medio ha sido actualizado correctamente.'
    redirect_to action: :index
  end

  def destroy
    @media_type.destroy
    respond_with(@media_type)
  end
  
  def bulk_delete
    ids = params[:ids].split(',')
    @media_types = MediaType.where("id in (?)", ids)
    flash[:notice] = []
    flash[:error] = []
    @media_types.each do |media_type|
      @media_media_types = MediaMediaType.where('media_type_id in (?)', media_type.id)
      if @media_media_types.present?
        flash[:error] << "Por favor, elimine los medios que pertenecen al tipo de medio \"" + media_type.name + "\" antes de borrarlo."
        next
      end

      flash[:notice] << 'El tipo de medio "' + media_type.name + '" ha sido elminado correctamente.'
      media_type.destroy
    end
    
    redirect_to :controller => :media_types, :action => :index
  end

  private
    def set_media_type
      @media_type = MediaType.find(params[:id])
    end
end
