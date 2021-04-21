class QuoteController < ApplicationController
    before_action :set_quote, only: [:show]

    def show
        if @quotes.size == 0
            @quotes = WebCrawler.request(params[:tag].downcase)
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
