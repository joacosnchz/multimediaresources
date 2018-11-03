class AttachmentsController < ApplicationController

  # GET /attachments
  # GET /attachments.json
  def index
    query = ''
    parameters = {}

    session.delete(controller_name.to_sym) if params[:reset] == 'true'
    session[controller_name.to_sym] = Hash.new if session[controller_name.to_sym].nil?

    if not params[:category_id].nil?
      session[controller_name.to_sym][:category_id] = params[:category_id]
    end

    if session[controller_name.to_sym][:category_id].present?
      query += 'category_id = :category_id '
      parameters[:category_id] = session[controller_name.to_sym][:category_id]
    end

    @attachments = Attachment.where(query, parameters).paginate(:page => params[:page]).order('attach_file_name ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(params[:attachment])
    @attachment.save

    flash[:notice] = 'El archivo ha sido subido correctamente.'

    return redirect_to :action => :index
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to attachments_path, notice: 'El archivo ha sido cambiado de categoria correctamente' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to attachments_url }
      format.json { head :no_content }
    end
  end

  def bulk_delete
    role = current_user.roles.first.name
    if role != 'admin'
      flash[:error] = "Solo usuarios administradores pueden borrar contenido."
      return redirect_to :action => :index
    end
    
    ids = params[:ids].split(',')
    @attachments = Attachment.where("id in (?)", ids)
    
    if @attachments.empty?
      flash[:error] = "No hay archivos para borrar."
      return redirect_to :action => :index
    end

    flash[:notice] = []
    flash[:error] = []
    @attachments.each do |attachment|
      if MaterialAttachment.where("attachment_id in (?)", attachment.id).present?
        flash[:error] << "Por favor, elimine todos los materiales que han adjuntado el archivo \"" + attachment.attach_file_name + "\" antes de borrarlo."
        next
      end
      flash[:notice] << "El archivo \"" + attachment.attach_file_name + "\" ha sido eliminado correctamente."
      
      attachment.destroy
    end

    redirect_to :action => :index
  end
  
  def download
    attachment_id = params[:attachment_id]
    attachment = Attachment.find(attachment_id)
    
    unique_download(attachment)
  end
  
  def bulk_download
    require 'zip'

    ids = params[:ids].split(',')
    @attachments = Attachment.where("id in (?)", ids)
    
    if @attachments.empty?
      flash[:error] = "No hay archivos para descargar."
      return redirect_to :action => :index
    end

    file_name = "archivos.zip"

    t = Tempfile.new("attachments-filename-#{Time.now}")
    zipfile_name = t.path

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      @attachments.each do |img|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        begin
          zipfile.add(img.attach_file_name, img.attach.path)
        rescue Zip::EntryExistsError
          next
        end
      end
      zipfile.get_output_stream("leeme.txt") { |os| os.write "Archivos descargados #{Time.now}" }
    end
    
    send_file t.path, :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => file_name
              t.close
  end
  
  private
    def unique_download(attachment)
      send_file attachment.attach.path,
              :filename => attachment.attach_file_name,
              :type => attachment.attach_content_type,
              :disposition => 'attachment'
    end
end
