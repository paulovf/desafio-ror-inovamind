require 'nokogiri'
require 'open-uri'

class WebCrawler
    URL = 'http://quotes.toscrape.com'
    
    def self.request(tag)
        begin
            request = Nokogiri::HTML(open(URL))
            resultList = createResultList(request)
            listQuotes = createListQuotes(resultList, tag)

            if listQuotes.size == 0
                request = Nokogiri::HTML(open("#{URL}/tag/#{tag}/"))
                resultList = createResultList(request)
                listQuotes = createListQuotes(resultList, tag)
            end            
            
            return listQuotes
        rescue
            return nil
        end
    end

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
