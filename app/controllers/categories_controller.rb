class CategoriesController < ApplicationController
  before_filter :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.paginate(:page => params[:page]).order('description ASC')
    respond_with(@categories)
  end

  def show
    respond_with(@category)
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])
    @category.save
    
    flash[:notice] = "La categor&iacute;a ha sido creada correctamente."
    
    return redirect_to :action => :index
  end

  def update
    @category.update_attributes(params[:category])

    flash[:notice] = "La categor&iacute;a ha sido modificada correctamente."
    
    return redirect_to :action => :index
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  def bulk_delete
    role = current_user.roles.first.name
    if role != 'admin'
      flash[:error] = "Solo usuarios administradores pueden borrar contenido."
      return redirect_to :action => :index
    end
    
    ids = params[:ids].split(',')
    @categories = Category.where("id in (?)", ids)
    
    if @categories.empty?
      flash[:error] = "No hay categorias para borrar."
      return redirect_to :action => :index
    end

    flash[:notice] = []
    flash[:error] = []
    @categories.each do |category|
      @attachments = Attachment.where('category_id in (?)', category.id)
      if @attachments.present?
        flash[:error] << "Por favor elimine todos los archivos de la categor&iacute;a \"" + category.description + "\" para poder eliminarla."
        next
      end
      flash[:notice] << "La categor&iacute;a \"" + category.description + "\" ha sido eliminada correctamente."
      
      category.destroy
    end

    return redirect_to :action => :index
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end
end
