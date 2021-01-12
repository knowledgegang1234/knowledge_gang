module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

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