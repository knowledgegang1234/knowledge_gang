config = {
  host: 'http://localhost:9200/',
  transport_options: {
    request: { timeout: 250 }
  },
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)