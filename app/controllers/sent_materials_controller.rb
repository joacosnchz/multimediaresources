class SentMaterialsController < ApplicationController
  before_filter :verify_role_permissions
  
  def verify_role_permissions
    role = current_user.roles.first.name
    return true if role == 'admin'
    
    unless ['admin'].include?(role)
      flash[:error] = "Acceso denegado!"
      redirect_to root_url
    end
  end
  
  # GET /sent_materials
  # GET /sent_materials.json
  def index
    @sent_materials = SentMaterial.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sent_materials }
    end
  end

  # GET /sent_materials/1
  # GET /sent_materials/1.json
  def show
    @sent_material = SentMaterial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sent_material }
    end
  end

  # GET /sent_materials/new
  # GET /sent_materials/new.json
  def new
    @sent_material = SentMaterial.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sent_material }
    end
  end

  # GET /sent_materials/1/edit
  def edit
    @sent_material = SentMaterial.find(params[:id])
  end

  # POST /sent_materials
  # POST /sent_materials.json
  def create
    @sent_material = SentMaterial.new(params[:sent_material])

    respond_to do |format|
      if @sent_material.save
        format.html { redirect_to @sent_material, notice: 'Sent material was successfully created.' }
        format.json { render json: @sent_material, status: :created, location: @sent_material }
      else
        format.html { render action: "new" }
        format.json { render json: @sent_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sent_materials/1
  # PUT /sent_materials/1.json
  def update
    @sent_material = SentMaterial.find(params[:id])

    respond_to do |format|
      if @sent_material.update_attributes(params[:sent_material])
        format.html { redirect_to @sent_material, notice: 'Sent material was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sent_material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sent_materials/1
  # DELETE /sent_materials/1.json
  def destroy
    @sent_material = SentMaterial.find(params[:id])
    @sent_material.destroy

    respond_to do |format|
      format.html { redirect_to sent_materials_url }
      format.json { head :no_content }
    end
  end

  def bulk_delete
    ids = params[:ids].split(',')
    SentMaterial.where("id in (?)", ids).delete_all

    flash[:notice] = "Los registros de envio han sido elminados correctamente."
    
    redirect_to action: :index
  end
end
