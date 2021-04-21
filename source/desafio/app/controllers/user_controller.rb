class UserController < ApplicationController
    before_action :authenticate_request, :set_user, only: [:update, :destroy]
    include BCrypt

    # Método responsável por criar um usuário
    def create
        if not Validators.is_email_valid?(user_params[:email])
            # Verifica se o email informado é válido
            msg = 'Invalid email'
            status = 404
        elsif user_params[:password] != user_params[:password_confirmation]
            # Verifica se as senhas informadas (principal e de confirmação) são iguais
            msg = 'Password does not match'
            status = 404
        elsif check_username(user_params[:email])
            # Verifica se o email informado já está sendo utilizado por outro usuário
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

    # Método responsável por alterar a senha do usuário
    def update
        if @user == nil
            # Verifica se o usuário informado na url de edição existe
            msg = 'Invalid email'
            status = 404        
        elsif user_params[:password] != user_params[:password_confirmation]
            # Verifica se as senhas informadas (principal e de confirmação) são iguais
            msg = 'Password does not match'
            status = 404
        else
            begin
                # gera o hash da nova senha
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

    # Método responsável por remover um usuário
    def destroy
        if @user == nil
            # Verifica se o usuário informado na url de exclusão existe
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
    
    # Método que faz a geração do hash da senha informada
    def generate_password_digest(new_password)
        return Password.create(new_password)
    end

    # Método que verifica se o email informado pertence a uma conta existente
    def check_username(email)
        return User.where(email: email).size > 0 ? true : false
    end

    def set_user
        # Caso o email informado não esteja ligado a nenhum usuário, é feito este tratamento
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
