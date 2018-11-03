class UsersController < ApplicationController
  before_filter :verify_role_permissions
  
  def verify_role_permissions
    role = current_user.roles.first.name
    return true if role == 'admin'
    
    unless ['admin'].include?(role)
      flash[:error] = "Acceso denegado!"
      redirect_to root_url
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    query = ''
    parameters = {}

    session.delete(controller_name.to_sym) if params[:reset] == 'true'
    session[controller_name.to_sym] = Hash.new if session[controller_name.to_sym].nil?

    if not params[:email].nil?
      session[controller_name.to_sym][:email] = params[:email]
    end
    if not params[:media_id].nil?
      session[controller_name.to_sym][:media_id] = params[:media_id]
    end

    if session[controller_name.to_sym][:email].present?
      query += 'email like :email '
      parameters[:email] = '%' + session[controller_name.to_sym][:email] + '%'

      if session[controller_name.to_sym][:media_id].present?
        query += 'AND '
      end
    end
    if session[controller_name.to_sym][:media_id].present?
      query += 'media_id = :media_id '
      parameters[:media_id] = session[controller_name.to_sym][:media_id]
    end
    @users = User.where(query, parameters).paginate(:page => params[:page]).order('email ASC')
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    errors = Array.new
    password = params[:user][:password]
    
    if User.find_by_email(params[:user][:email])
      errors << t('custom_errors.profile.email.already_exists')
      @user.errors[:email] << t('custom_errors.profile.email.already_exists')
    end
    
    unless params[:user][:password].present?
      errors << t('custom_errors.profile.password.incomplete')
      @user.errors[:password] << t('custom_errors.profile.password.incomplete')
    end

    if password.length < 6
      errors << t('custom_errors.profile.password.too_short')
      @user.errors[:password] << t('custom_errors.profile.password.incomplete')
    end
    
    unless errors.empty?
      flash[:error] = errors.join("<br/>")
      return render action: "new"
    end
    
    respond_to do |format|
      if @user.save
        flash[:notice] = "El usuario ha sido creado correctamente, un email de confirmacion ha sido enviado a este usuario."

        @user.add_role params[:role].to_sym
        
        format.html { redirect_to action: "index" }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])

    flash[:notice] = "El usuario ha sido actualizado correctamente."

    respond_to do |format|
      if @user.update_attributes(params[:user])
        @user.roles.delete_all
        @user.add_role params[:role].to_sym
        
        format.html { redirect_to action: "index" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def bulk_delete
    ids = params[:ids].split(',')
    @users = User.where("id in (?)", ids)
    flash[:notice] = []
    flash[:error] = []
    @users.each do |user|
      SentMaterial.where('user_id in (?)', user.id).delete_all

      flash[:notice] << "El usuario \"" + user.email + "\" ha sido elminado correctamente."
      user.destroy
    end
        
    redirect_to :controller => :users, :action => :index
  end
  
  def password_update
    unless params[:user][:password].present? and params[:user][:password_verification].present?
      flash[:error] = t('custom_errors.profile.password.incomplete')
      return redirect_to profile_edit_path
    end

    password = params[:user][:password]
    verification = params[:user][:password_verification]
    
    if password != verification
      flash[:error] = t('custom_errors.profile.password.no_match')
      return redirect_to profile_edit_path
    end
    
    current_user.password = password

    if current_user.save
      flash[:notice] = t('custom_errors.profile.password.updated')
    else
      flash[:error] = []
      current_user.errors.messages.each do |key, values|
        values.each do |value|
          flash[:error] << "#{value}\n"
        end
      end
      
    end
    
    return redirect_to profile_edit_path
  end
end
