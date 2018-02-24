class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_pagination, only: [:index]

  def index
    @users = User.order(:id).limit(@size).offset(@page * @size)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        update_user_tags

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        update_user_tags

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def update_user_tags
      tag_names = params[:user][:tags]
      new_tag_ids = []

      if tag_names.present?
        tag_names.split.each do |tag_name|
          tag = Tag.find_or_create_by!(name: tag_name)
          new_tag_ids << tag.id
        end
      end

      @user.update tag_ids: new_tag_ids.uniq
    end

    def set_pagination
       @page = params[:page].to_i
       @size = params[:size] ? params[:size].to_i : User::USERS_PER_PAGE
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
