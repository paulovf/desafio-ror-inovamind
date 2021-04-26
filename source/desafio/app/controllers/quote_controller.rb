class QuoteController < ApplicationController
    before_action :authenticate_request, :set_quote, only: [:show]

    def index
        render json: {'info': 'Desafio Ruby-on-Rails InovaMind. Desenvolvido por: Paulo Vitor Francisco - 2021'}, 
            adapter: :json
    end

    # Exibe todas as frases que contenha a tag informada, na qual esta tag esteja no array de tags
    def show
        # Se o array de quotes for maior que zero, significa que as frases foram trazidas do banco de
        # dados
        if @quotes.size == 0
            # caso o array de quotes tenha tamanho zero, será feita a pesquisa das frase no site
            @quotes = WebCrawler.request(params[:tag].downcase)
            # Caso ocorra algum erro na pesquisa, é retornada uma lista vazia
            if @quotes == nil
                @quotes = []
            end
        end
        render json: {'quotes': @quotes.as_json.each{ |item| item.delete("_id")}}, adapter: :json
    end

    private

    def set_quote
        @quotes = Quote.in(tags: [params[:tag].downcase])
    end

    def quote_params
        params.require(:quote).permit(:quote, :author, :author_about, :tags)
    end
end
