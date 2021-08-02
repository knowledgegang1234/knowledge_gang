class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  def perform(operation, class_name, record_id)
    case operation.to_s
      when /index/
        begin
          record = class_name.constantize.find_by(id: record_id)
          return if record.blank?
          Elasticsearch::Model.client.index  index: record.class.table_name, id: record.id, body: record.__elasticsearch__.as_indexed_json
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
        end
      when /delete/
        begin
          Elasticsearch::Model.client.delete index: 'blogs', id: record_id
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
        end
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end