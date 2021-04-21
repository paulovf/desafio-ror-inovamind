class Quote
    include Mongoid::Document

    field :quote, type: String, default: ""
    field :author, type: String, default: ""
    field :author_about, type: String, default: ""
    field :tags, type: Array, default: []
end
