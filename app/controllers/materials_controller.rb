class MaterialsController < ApplicationController
  before_filter :set_material, only: [:show, :edit, :update, :destroy, :attachment_delete, :attachment_download]
  before_filter :verify_role_permissions, except: [:show, :my_materials, :show, :attachment_download]
  
  respond_to :html
  
  def verify_role_permissions
    role = current_user.roles.first.name
    return true if role == 'admin'
    
    unless ['admin', 'publisher'].include?(role)
      flash[:error] = "Acceso denegado!"
      redirect_to root_url
    end
  end
  
  def index
    query = ''
    parameters = {}
    
    session.delete(controller_name.to_sym) if params[:reset] == 'true'
    session[controller_name.to_sym] = Hash.new if session[controller_name.to_sym].nil?
    
    if not params[:title].nil?
      session[controller_name.to_sym][:title] = params[:title]
    end
    if session[controller_name.to_sym][:title].present? 
      query += 'title like :title '
      parameters[:title] = '%' + session[controller_name.to_sym][:title] + '%'
    end

    if not params[:fecha].nil?
      session[controller_name.to_sym][:fecha] = params[:fecha]
    end
    if session[controller_name.to_sym][:fecha].present?
      if session[controller_name.to_sym][:title].present?
        query += 'AND '
      end
      query += 'created_at >= :created_at '
      parameters[:created_at] = session[controller_name.to_sym][:fecha].to_date.to_time
    end

    @materials = Material.where(query, parameters).paginate(:page => params[:page])

    if not params[:orden].nil?
      session[controller_name.to_sym][:orden] = params[:orden]
    end
    if session[controller_name.to_sym][:orden].present?
      if session[controller_name.to_sym][:orden] == 'created_at'
        @materials = @materials.order(session[controller_name.to_sym][:orden] + ' DESC')
      else
        @materials = @materials.order(session[controller_name.to_sym][:orden] + ' ASC')
      end
    else
      session[controller_name.to_sym][:orden] = 'created_at'
      @materials = @materials.order(session[controller_name.to_sym][:orden] + ' DESC')
    end

    if not params[:media_id].nil?
      session[controller_name.to_sym][:media_id] = params[:media_id]
    end
    if session[controller_name.to_sym][:media_id].present?
      material_media = MaterialMedia.where('media_id in (?)', session[controller_name.to_sym][:media_id])
      filteredMaterials = []
      material_media.each do |mat_med|
        filteredMaterials << Material.find_by_id(mat_med.material_id)
      end
      @materials = @materials.delete_if { |material|
        filteredMaterials.exclude? material
      }
    end

    if not params[:media_type_id].nil?
      session[controller_name.to_sym][:media_type_id] = params[:media_type_id]
    end
    if session[controller_name.to_sym][:media_type_id].present?
      material_media_type = MaterialMediaType.where('media_type_id in (?)', session[controller_name.to_sym][:media_type_id])
      filteredMaterials = []
      material_media_type.each do |mat_medt|
        filteredMaterials << Material.find_by_id(mat_medt.material_id)
      end
      @materials = @materials.delete_if {|material|
        filteredMaterials.exclude? material
      }
    end

    @sent_materials = SentMaterial.all

    if not params[:envios].nil?
      session[controller_name.to_sym][:envios] = params[:envios]
    end
    if session[controller_name.to_sym][:envios].present?
      filteredMaterials = []
      @sent_materials.each do |sent_mat|
        filteredMaterials << Material.find_by_id(sent_mat.material_id)
      end
      if session[controller_name.to_sym][:envios] == 'env'
        @materials = @materials.delete_if {|material|
          filteredMaterials.exclude? material
        }
      else
        @materials = @materials.delete_if {|material|
          filteredMaterials.include? material
        }
      end
    end

    return render "index"
  end

  def show
    #if current_user.get_role == :consumer and current_user.materials.find_by_id(@material.id).nil?
      #flash[:error] = "Lo sentimos, aparentemente usted no tiene acceso al material solicitado, si deberia tenerlo, por favor comuniquese con el editor responsable.!"  
      #return redirect_to root_url
    #end
    
    respond_with(@material)
  end

  def new
    @material = Material.new
    @media_types = MediaType.order('name').all
    @archivos = Attachment.order('attach_file_name ASC')
    respond_with(@material)
  end

  def edit
    @media_types = MediaType.order('name').all
    @archivos = Attachment.order('attach_file_name ASC')
    # Completar con los tipos de medios seleccionados
    @material_media_types = MaterialMediaType.where('material_id in (?)', @material.id)
    @selected_media_types = []
    @material_media_types.each do |material_media_type|
      @media_type = MediaType.find_by_id(material_media_type.media_type_id)
      @selected_media_types << @media_type
    end
    # EOF tipos de medios
    # Completar con los medios seleccionados
    @material_medias = MaterialMedia.where('material_id in (?)', @material.id)
    @selected_medias = []
    @material_medias.each do |material_media|
      @media = Media.find_by_id(material_media.media_id)
      @selected_medias << @media
    end
    # EOF medios
  end

  def create
    # Cargar medios a partir de tipo de medio
    if params[:filtro_tm].present?
      @media_media_types = MediaMediaType.where('media_type_id in (?)', params[:filtro_tm])
      @medias = []
      @media_media_types.each do |m_m_t|
        @media = Media.find_by_id(m_m_t.media_id)
        @medias << @media
      end
      return render '_media_filter', :layout => false
    end

    # Agregar medios
    if params[:id_tipomedio].present?      
        @media_media_types = MediaMediaType.where("media_type_id in (?)", params[:id_tipomedio])
        @medias = []
        @media_media_types.each do |media_media_type|
          @media = Media.find_by_id(media_media_type.media_id)
          if @media.present?
            @medias << @media
          end
        end
        return render "_media", :layout => false
    end

    media_types = params[:material][:media_type]
    medias = params[:material][:media]
    attachments = params[:material][:attachments].split(',')
    adjuntos = params[:material][:adjuntos]
    allMedias = params[:material][:allMedias] # boolean

    params[:material].delete(:media_type)
    params[:material].delete(:media)
    params[:material].delete(:attachments)
    params[:material].delete(:allMedias)
    params[:material].delete(:adjuntos)
    
    @material = Material.new(params[:material])
    @media_types = MediaType.all

    if allMedias == '0'
      # Eliminar tipos de medios duplicados
      @tmedios = []
      if media_types.respond_to?('each')
        media_types.each do |key, media_type|
          if not @tmedios.include?(media_type)
            @tmedios << media_type
          end
        end
      else
        flash[:error] = "Debe seleccionar al menos un tipo de medio."
        # retornar al formulario
        return redirect_to(:back)
      end

      # Eliminar medios duplicados
      @medios = []
      if medias.respond_to?('each')
        medias.each do |key, media|
          if not @medios.include?(media)
            @medios << media
          end
        end
      else
        flash[:error] = "Debe seleccionar al menos un medio."
        # retornar al formulario
        return redirect_to(:back)
      end
    end

    @material.save

    if allMedias == '0'
      # Guardar tipos de medios seleccionados en la tabla intermedia MaterialMediaType
      @tmedios.each do |media_type|
        @media_type = MediaType.find_by_id(media_type)
        if @media_type.present?
          @material_media_type = MaterialMediaType.new
          @material_media_type.material = @material
          @material_media_type.media_type = @media_type
          @material_media_type.save
        end
      end

      # Guardar medios seleccionados en la tabla intermedia MaterialMedia
      @medios.each do |media|
        @media = Media.find_by_id(media)
        if @media.present?
          @material_media = MaterialMedia.new
          @material_media.material = @material
          @material_media.media = @media
          @material_media.save
        end
      end
    else
      # Guardar tipos de medios seleccionados en la tabla intermedia MaterialMediaType
      MediaType.all.each do |media_type|
        @material_media_type = MaterialMediaType.new
        @material_media_type.material = @material
        @material_media_type.media_type = media_type
        @material_media_type.save
      end

      # Guardar medios seleccionados en la tabla intermedia MaterialMedia
      Media.all.each do |media|
        @material_media = MaterialMedia.new
        @material_media.material = @material
        @material_media.media = media
        @material_media.save
      end
    end
    
    # Guardar los archivos seleccionados en la table intemedia MaterialAttachment
    if attachments.respond_to?('each') # Puede que no se seleccionen archivos
      attachments.each do |attach|
        @attachment = Attachment.find(attach)
        if @attachment.present?
          @material_attachment = MaterialAttachment.new
          @material_attachment.material = @material
          @material_attachment.attachment = @attachment
          @material_attachment.save
        end
      end
    end

    # Guardar los archivos adjuntados en la tabla intermedia MaterialAttachment
    if adjuntos.respond_to?('each') # Puede que no se adjunten archivos
      adjuntos.each do |_, adjunto|
        adj = Attachment.new(:attach => adjunto)
        adj.save
        @material_attachment = MaterialAttachment.new
        @material_attachment.material = @material
        @material_attachment.attachment = adj
        @material_attachment.save
      end
    end

    flash[:notice] = "El material ha sido creado correctamente."
    redirect_to action: :index
  end

  def update
    media_types = params[:material][:media_type]
    medias = params[:material][:media]
    attachments = params[:material][:attachments].split(',')
    adjuntos = params[:material][:adjuntos]
    allMedias = params[:material][:allMedias] # boolean
    
    params[:material].delete(:media_type)
    params[:material].delete(:media)
    params[:material].delete(:attachments)
    params[:material].delete(:adjuntos)
    params[:material].delete(:allMedias)

    @media_types = MediaType.all
    
    if allMedias == '0'
      # Eliminar tipos de medios duplicados
      @tmedios = []
      if media_types.respond_to?('each')
        media_types.each do |key, media_type|
          if not @tmedios.include?(media_type)
            @tmedios << media_type
          end
        end
      else
        flash[:error] = "Debe seleccionar al menos un tipo de medio."
        # retornar al formulario
        return redirect_to(:back)
      end

      # Eliminar medios duplicados
      @medios = []
      if medias.respond_to?('each')
        medias.each do |key, media|
          if not @medios.include?(media)
            @medios << media
          end
        end
      else
        flash[:error] = "Debe seleccionar al menos un medio."
        # retornar al formulario
        return redirect_to(:back)
      end
    end

    # Actualizar
    @material.update_attributes(params[:material])
    
    # Eliminar asociaciones viejas
    MaterialMediaType.where('material_id in (?)', @material.id).delete_all
    MaterialMedia.where('material_id in (?)', @material.id).delete_all
    MaterialAttachment.where('material_id in (?)', @material.id).delete_all

    if allMedias == '0'
      # Guardar tipos de medios seleccionados en la tabla intermedia MaterialMediaType
      @tmedios.each do |media_type|
        @media_type = MediaType.find_by_id(media_type)
        if @media_type.present?
          @material_media_type = MaterialMediaType.new
          @material_media_type.material = @material
          @material_media_type.media_type = @media_type
          @material_media_type.save
        end
      end

      # Guardar medios seleccionados en la tabla intermedia MaterialMedia
      @medios.each do |media|
        @media = Media.find_by_id(media)
        if @media.present?
          @material_media = MaterialMedia.new
          @material_media.material = @material
          @material_media.media = @media
          @material_media.save
        end
      end
    else
      # Guardar tipos de medios seleccionados en la tabla intermedia MaterialMediaType
      MediaType.all.each do |media_type|
        @material_media_type = MaterialMediaType.new
        @material_media_type.material = @material
        @material_media_type.media_type = media_type
        @material_media_type.save
      end

      # Guardar medios seleccionados en la tabla intermedia MaterialMedia
      Media.all.each do |media|
        @material_media = MaterialMedia.new
        @material_media.material = @material
        @material_media.media = media
        @material_media.save
      end
    end
    
    # Guardar los archivos seleccionados en la table intemedia MaterialAttachment
    if attachments.respond_to?('each') # Puede que no se seleccionen archivos
      attachments.each do |attach|
        @attachment = Attachment.find(attach)
        if @attachment.present?
          @material_attachment = MaterialAttachment.new
          @material_attachment.material = @material
          @material_attachment.attachment = @attachment
          @material_attachment.save
        end
      end
    end

    # Guardar los archivos adjuntados en la tabla intermedia MaterialAttachment
    if adjuntos.respond_to?('each') # Puede que no se adjunten archivos
      adjuntos.each do |_, adjunto|
        adj = Attachment.new(:attach => adjunto)
        adj.save
        @material_attachment = MaterialAttachment.new
        @material_attachment.material = @material
        @material_attachment.attachment = adj
        @material_attachment.save
      end
    end

    flash[:notice] = "El material ha sido actualizado correctamente."
    redirect_to action: :index
  end

  def destroy
    @material.destroy
    respond_with(@material)
  end
  
  def bulk_delete
    ids = params[:ids].split(',')
    @materiales = Material.where("id in (?)", ids)
    flash[:notice] = []
    @materiales.each do |material|
      MaterialMedia.where("material_id in (?)", material.id).delete_all
      MaterialMediaType.where("material_id in (?)", material.id).delete_all
      MaterialAttachment.where("material_id in (?)", material.id).delete_all
      SentMaterial.where("material_id in (?)", material.id).delete_all

      flash[:notice] << 'El material "' + material.title + '" ha sido elminado correctamente.'
      material.destroy
    end
    
    redirect_to :controller => :materials, :action => :index
  end
  
  def send_mail
    ids = params[:ids].split(',')
    materials = Material.where("id in (?)", ids).all
    
    flash[:notice] = []
    materials.each do |material|
      @materials_media = MaterialMedia.where("material_id in (?)", material.id)
      @attachments = Attachment.where("material_id in (?)", material.id)
      @materials_media.each do |material_media|
        @users = User.where("media_id in (?)", material_media.media_id)
        @users.each do |user|
          # Enviar el material.body al email user.email
          user.send_material_email(material)
        end
        # Registrar envio del material (aditoria)
      end

      @sent_mat = SentMaterial.new
      @sent_mat.user = current_user
      @sent_mat.material = material
      @sent_mat.save

      flash[:notice] << "El material \"" + material.title + "\" ha sido enviado por mail correctamente."
    end
    
    redirect_to :controller => :materials, :action => :index
  end
  
  def attachment_delete
    attachment_id = params[:attachment_id]
    attachment = @material.attachments.where("id = ?", attachment_id).first
    attachment.delete unless attachment.nil?
    
    return render json: { status: true }
  end
  
  def attachment_download
    attachment_id = params[:attachment_id]
    attachment = @material.attachments.where("id = ?", attachment_id).first
    
    if not attachment.nil?
      send_file attachment.attach.path,
              :filename => attachment.attach_file_name,
              :type => attachment.attach_content_type,
              :disposition => 'attachment'
    else
      flash[:error] = 'Disculpe, El archivo ya no existe en el servidor.'

      redirect_to :controller => :home, :action => :index
    end
  end

  def my_materials
    session[controller_name.to_sym] = Hash.new if session[controller_name.to_sym].nil?
    
    @materials_filtered = []
    @material_medias = MaterialMedia.where('media_id in (?)', current_user.media_id)
    @material_medias.each do |material_media|
      @material = Material.find_by_id(material_media.material_id)
      @materials_filtered << @material
    end

    @materials = Material.paginate(:page => params[:page], :per_page => 10).order('title ASC')
    @materials = @materials.delete_if { |material| 
      @materials_filtered.exclude? material
    }

    @sent_materials = SentMaterial.all

    return render "index"
  end
  
  def material_to_pdf
    ids = params[:material_id].split(',')
    # http://viget.com/extend/how-to-create-pdfs-in-rails
    
    @materials = Material.where('id in (?)', ids).all
    html = render_to_string(:action => :material_to_pdf, :layout => false) 
    pdf = WickedPdf.new.pdf_from_string(html) 
    send_data(pdf, 
      :filename    => "materiales.pdf", 
      :disposition => 'attachment')
  end
  
  def download_zip
    require 'zip'

    material = Material.find(params[:material_id])
    image_list = material.attachments
    
    file_name = "archivos_material_" + material.id.to_s + ".zip"
    
    t = Tempfile.new("attachments-filename-#{Time.now}")
    zipfile_name = t.path

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      image_list.each do |img|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        begin
          zipfile.add(img.attach_file_name, img.attach.path)
        rescue Zip::EntryExistsError
          next
        end
      end
      zipfile.get_output_stream("leeme.txt") { |os| os.write "Archivos del material: " + material.title }
    end
    
    send_file t.path, :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => file_name
    t.close
  end

  def get_files
    ids = params[:material_attachments].split(',')
    archivos = Attachment.where("id in (?)", ids).all

    if archivos.present?
      return render '_attachments_show', :layout => false, :locals => {:archivos => archivos}
    end
  end

  def attach_table_by_category
    id = params[:category_id]

    if not id.empty?
      archivos = Attachment.where('category_id in (?)', id).collect{|att| att.id}
    else
      archivos = Attachment.all.collect{|att| att.id}
    end

    return render :json => archivos
    #return render 'materials/includes/_images_table', :layout => false
  end
  
  private
    def set_material
      @material = Material.find(params[:id])
    end
end
