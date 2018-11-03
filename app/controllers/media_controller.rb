class MediaController < ApplicationController
  before_filter :set_media, only: [:show, :edit, :update, :destroy]
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
    query = ''
    parameters = {}

    session.delete(controller_name.to_sym) if params[:reset] == 'true'
    session[controller_name.to_sym] = Hash.new if session[controller_name.to_sym].nil?

    if not params[:nombre].nil?
      session[controller_name.to_sym][:nombre] = params[:nombre]
    end

    if session[controller_name.to_sym][:nombre].present?
      query += 'nombre like :nombre'
      parameters[:nombre] = '%' + session[controller_name.to_sym][:nombre] + '%'
    end

    @media = Media.where(query, parameters).paginate(:page => params[:page]).order('nombre ASC')

    if not params[:media_type_id].nil?
      session[controller_name.to_sym][:media_type_id] = params[:media_type_id]
    end
    if session[controller_name.to_sym][:media_type_id].present?
      @filteredMedias = []
    	@media_media_type = MediaMediaType.where('media_type_id in (?)', session[controller_name.to_sym][:media_type_id])
    	@media_media_type.each do |med_med_t|
    		@filteredMedias << Media.find_by_id(med_med_t.media_id)
    	end
    	@media = @media.delete_if {|media|
    		@filteredMedias.exclude? media
    	}
    end

    return render "index"
  end

  def show
    respond_with(@media)
  end

  def new
    @media = Media.new
    @media_types = MediaType.all
    respond_with(@media)
  end

  def edit
    # Completar los medios ya seleccionados
    @medias_media_type = MediaMediaType.where("media_id in (?)", @media.id)
    @media_types = MediaType.all
    @selectedMedias = []
    @medias_media_type.each do |media_media_type|
      @media_type = MediaType.find_by_id(media_media_type.media_type_id)
      if @media.present?
        @selectedMedias << @media_type
      end
    end
    # EOF completar medios seleccionados
  end

  def create    
    if params[:media][:media_type].present?
      media_types = params[:media][:media_type]
      params[:media].delete(:media_type)
    end

    @media = Media.new(params[:media])
    @media.save
    
    @arr = []
    if media_types
      # Eliminar duplicados de los tipos de medios seleccionados
      media_types.each do |key, media_type_id|
        if not @arr.include?(media_type_id)
          @arr << media_type_id
        end
      end
      
      # Guardar los tipos de medios seleccionados en la table intermedia MediaMediaType
      @arr.each do |media_type_id|
        @media_type = MediaType.find_by_id(media_type_id)
        if @media_type.present?
          @media_media_type = MediaMediaType.new
          @media_media_type.media = @media
          @media_media_type.media_type = @media_type
          @media_media_type.save
        end
      end
    end

    flash[:notice] = "El medio ha sido creado correctamente."
    redirect_to action: :index
  end

  def update
    if params[:media][:media_type].present?
      media_types = params[:media][:media_type]
      params[:media].delete(:media_type)
    end

    # Medio no puede ser actualizado si está seleccionado en algun material
    @material_media = MaterialMedia.where("media_id in (?)", @media.id)
    if @material_media.present?
      flash[:error] = "No se ha podido actualizar \"" + @media.nombre + "\" ya que hay materiales que son enviados a este medio."
      return redirect_to(:back)
    end
    
    @media.update_attributes(params[:media])
    # Eliminar los tipos de medios anteriores asociados a este medio
    MediaMediaType.where("media_id in (?)", @media.id).delete_all

    @arr = []
    if media_types
      # Eliminar duplicados de los tipos de medios seleccionados
      media_types.each do |key, media_type_id|
        if not @arr.include?(media_type_id)
          @arr << media_type_id
        end
      end
  
      # Guardar los tipos de medios seleccionados en la table intermedia MediaMediaType
      @arr.each do |media_type_id|
        @media_type = MediaType.find_by_id(media_type_id)
        if @media_type.present?
          @media_media_type = MediaMediaType.new
          @media_media_type.media = @media
          @media_media_type.media_type = @media_type
          @media_media_type.save
        end
      end
    end
    
    flash[:notice] = "El medio \"" + @media.nombre + "\" ha sido actualizado correctamente."
    redirect_to action: :index
  end

  def destroy
    @media.destroy
    respond_with(@media)
  end
  
  def bulk_delete
    ids = params[:ids].split(',')
    @medios = Media.where("id in (?)", ids)
    flash[:notice] = []
    flash[:error] = []
    @medios.each do |media|
      @material_media = MaterialMedia.where("media_id in (?)", media.id)
      if @material_media.present?
        flash[:error] << "Por favor elimine los materiales que pueden ser enviados al medio \"" + media.nombre + "\" antes de borrarlo."
        next
      end
      @users = User.where("media_id in (?)", media.id)
      if @users.present?
        flash[:error] << "Por favor elimine los usuarios del medio \"" + media.nombre + "\" antes de borrarlo."
        next
      end
      
      MediaMediaType.where("media_id in (?)", media.id).delete_all
      flash[:notice] << 'El medio "' + media.nombre + '" ha sido elminado correctamente.'
      media.destroy
    end
    
    redirect_to :controller => :media, :action => :index
  end

  private
    def set_media
      @media = Media.find(params[:id])
    end
end
