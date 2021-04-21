class AuthenticateUser
    prepend SimpleCommand
  
    def initialize(email, password)
        @email = email
        @password = password
    end
  
    def call
        JsonWebToken.encode(user_id: user.id) if user
    end
  
    private
  
    attr_accessor :email, :password
  
    def user
        user = User.where(email: email)
        if user.size > 0
            user = user[0]
        else
            user = nil
        end
        #begin
            return user if user && user.authenticate(password)
        #rescue

        #end
        errors.add :user_authentication, 'invalid credentials'
        nil
    end
end