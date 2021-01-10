module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings analysis: {
      index_analyzer: {
        my_index_analyzer: {
          type: "custom",
          tokenizer: "standard",
          filter: [
            "lowercase",
            "mynGram"
          ]
        }
      },
      search_analyzer: {
        my_search_analyzer: {
          type: "custom",
          tokenizer: "standard",
          filter: [
            "standard",
            "lowercase",
            "mynGram"
          ]
        }
      },
      filter: {
        mynGram: {
          type: "nGram",
          min_gram: 2,
          max_gram: 50
        }
      }
    }

    after_commit on: [:create, :update] do
      es_reindex
    end

    after_commit on: [:destroy] do
      es_delete_index
    end

    def es_reindex
      Indexer.new.perform(:index, self.class.name, self.id)
    end

    def es_delete_index
      Indexer.new.perform(:delete, self.class.name, self.id)
    end
  end

end