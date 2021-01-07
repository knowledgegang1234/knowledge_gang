class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  def perform(operation, class_name, record_id)
    case operation.to_s
      when /index/
        record = class_name.constantize.find(record_id)
        Elasticsearch::Model.client.index  index: 'blogs', id: record.id, body: record.__elasticsearch__.as_indexed_json
      when /delete/
        begin
          Elasticsearch::Model.client.delete index: 'blogs', id: record_id
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
        end
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end