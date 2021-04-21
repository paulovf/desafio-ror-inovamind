class Validators
    REGEX_PATTERN = /^(.+)@(.+)$/ 
    
    def self.is_email_valid? email
        email =~REGEX_PATTERN
    end
end
