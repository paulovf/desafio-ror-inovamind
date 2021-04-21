class Validators
    # Classe que contém método(s) padrão(ões) de validação do sistema
    REGEX_PATTERN = /^(.+)@(.+)$/ 
    
    # Método que verifica se o email informado é válido
    def self.is_email_valid? email
        email =~REGEX_PATTERN
    end
end
