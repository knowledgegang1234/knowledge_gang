class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  def perform(operation, record_id)
    case operation.to_s
      when /index/
        record = Blog.find(record_id)
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