require 'nokogiri'
require 'open-uri'

class WebCrawler
    # Classe que contém os métods responsáveis pela busca das frase no site quotes.toscrape.com e o seu 
    # armazenamento no banco de dados
    URL = 'http://quotes.toscrape.com'
    
    # Método que faz a requisição HTTP para o site quotes.toscrape.com
    def self.request(tag)
        begin
            # Requisição feita na página inicial do site quotes.toscrape.com
            listQuotes = sendRequest(URL, tag)

            # Caso não tenha sido encontrada a tag nformada na página inicial, é feita uma outra pesquisa
            # no site quotes.toscrape.com, desta vez, passando a tag pesquisada como parâmetro da URL
            if listQuotes.size == 0
                listQuotes = sendRequest("#{URL}/tag/#{tag}/", tag)
            end
            
            return listQuotes
        rescue
            return nil
        end
    end

    # Método que envia a requisição de busca das frases para o site quotes.toscrape, de acordo com a
    # URL passada como parâmetro
    def self.sendRequest(url, tag)
        request = Nokogiri::HTML(open(url))
        resultList = createResultList(request)
        return createListQuotes(resultList, tag)
    end

    # Método que cria uma lista contendo as informações rastreadas da página html vindas da requisição ao site
    # quotes.toscrape.com
    def self.createResultList(request)
        return request.css(".quote").map{
            |item| [
                item.css(".text").text, 
                item.search("span").search("small").text, 
                item.search("span").search("a").first.values, 
                item.css(".tags").search("a").map{|subitem| subitem.text}
            ] 
        }
    end

    # Método que cria a lista de objetos Quote de acordo com os dados vindos da lista de conteúdos rastreados do
    # site quotes.toscrape.com
    def self.createListQuotes(resultList, tag)
        listQuotes = []
        resultList.each do |elements|
            if elements[3].include? tag
                @objQuote = save(elements)
                if @objQuote != nil
                    listQuotes << @objQuote
                end
            end
        end
        return listQuotes
    end

    # Método que faz a gravação do objeto Quote no banco de dados
    def self.save(elements)
        begin
            @quote = Quote.find_or_create_by(
                quote: elements[0],
                author: elements[1],
                author_about: URL + elements[2][0],
                tags: elements[3]
            )
        rescue
            @quote = nil
        end
        return @quote
    end
end
