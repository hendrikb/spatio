require 'resque'

get '/api/import' do
  require './lib/spatio'

  response_is_json
  Import.all.to_json
end

post '/api/import/new' do
  response_is_json

  begin
    format = FormatDefinition.find(params['format_definition'])
  rescue
    json_err 'Invalid FormatDefinition'
  end

  import = Import.create name: params['name'],
    namespace: params['namespace'],
    geo_context: params['geo_context'],
    url: params['url'],
    format_definition: format,
    description: params['description']

  json_errors import.errors unless import.persisted?
  okay
end

get '/api/import/:id/run' do
  response_is_json
  import = Import.find(params[:id])
  if Resque.enqueue(Spatio::ImportJob, import.id)
    okay
  else
    json_err "Enqueing this task did not work out"
  end
end

