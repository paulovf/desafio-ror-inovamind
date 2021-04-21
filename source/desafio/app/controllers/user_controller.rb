class UserController < ApplicationController
    before_action :authenticate_request, :set_user, only: [:update, :destroy]
    include BCrypt

    def create
        if not Validators.is_email_valid?(user_params[:email])
            msg = 'Invalid email'
            status = 404        
        elsif user_params[:password] != user_params[:password_confirmation]
            msg = 'Password does not match'
            status = 404
        elsif check_username(user_params[:email])
            msg = 'User already registered'
            status = 404
        else
            begin
                @user = User.new(user_params)
                if @user.save
                    msg = 'User created successfully'
                    status = 200
                else
                    msg = 'Error creating user. Check the fields'
                    status = 404
                end
            rescue
                msg = 'Internal server error.'
                status = 500
            end
        end
        render json: {msg: msg}, status: status
    end

    def update
        if @user == nil
            msg = 'Invalid email'
            status = 404        
        elsif user_params[:password] != user_params[:password_confirmation]
            msg = 'Password does not match'
            status = 404
        else
            begin
                @user.password_digest = generate_password_digest(user_params[:password])
                if @user.save
                    msg = 'User updated successfully'
                    status = 201
                else
                    msg = 'Error updating user. Check the fields'
                    status = 404
                end
            rescue
                msg = 'Internal server error.'
                status = 500
            end
        end
        render json: {msg: msg}, status: status
    end

    def destroy
        if @user == nil
            msg = 'User not registered'
            status = 404
        else
            begin
                if @user.delete
                    msg = 'User removed successfully'
                    status = 200
                else
                    msg = 'Error removing user. Check the fields'
                    status = 404
                end
            rescue
                msg = 'Internal server error.'
                status = 500
            end
        end
        render json: {msg: msg}, status: status
    end

    private
    
    def generate_password_digest(new_password)
        return Password.create(new_password)
    end

    def check_username(email)
        return User.where(email: email).size > 0 ? true : false
    end

    def set_user
        begin
            @user = User.where(email: params[:id])[0]
        rescue
            @user = nil
        end
    end

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
