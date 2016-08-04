require 'bundler'
require_relative './lib/sentimental.rb'
require_relative './lib/summarize.rb'
Bundler.require
configure { set :server, :puma }

before do
  pass if request.request_method.upcase == 'GET'

  if env["HTTP_AUTHORIZATION"] == 'Token=cc628bs56kv1qf2wf32jyk4h0000gn'
    @start = Time.now
    pass
  else
    halt 403
  end
end

get '/' do
  "#{Time.now} : I am UP"
end

post '/detect_encoding' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content'].to_s
  CharlockHolmes::EncodingDetector.detect(content).to_json
end

post '/to_utf_8' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  d = CharlockHolmes::EncodingDetector.detect(content)
  { content: CharlockHolmes::Converter.convert(x , d[:encoding], 'UTF-8') }.to_json
end

post '/sentiment' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  halt 422 if content.nil?
  processor = Sentimental.new

  {
    sentiment: processor.process(content),
    ttl: "#{(Time.now - @start).round(3)} sec"
  }.to_json
end

post '/stem_sentiment' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  halt 422 if content.nil?
  processor = Sentimental.new

  {
    stem_sentiment: processor.process(content, true),
    ttl: "#{(Time.now - @start).round(3)} sec"
  }.to_json
end

post '/summary' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  halt 422 if content.nil?
  processor = Summarize.new

  {
    summary: processor.process(content),
    ttl: "#{(Time.now - @start).round(3)} sec"
  }.to_json
end

post '/summary_sentiment' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  halt 422 if content.nil?
  summary = Summarize.new.process content
  processor = Sentimental.new

  {
    sentiment: processor.process(summary),
    summary: summary,
    ttl: "#{(Time.now - @start).round(3)} sec"
  }.to_json
end

post '/stem_summary_sentiment' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  halt 422 if content.nil?
  summary = Summarize.new.process content
  processor = Sentimental.new

  {
    sentiment: processor.process(summary),
    stem_sentiment: processor.process(summary, true),
    summary: summary,
    ttl: "#{(Time.now - @start).round(3)} sec"
  }.to_json
end

post '/all' do
  content_type :json
  params = JSON.parse(request.body.read)
  content = params['content']
  halt 422 if content.nil?
  summary = Summarize.new.process content
  processor = Sentimental.new

  {
    sentiment: processor.process(content),
    stem_sentiment: processor.process(content, true),
    summarized_sentiment: processor.process(summary),
    stem_summarized_sentiment: processor.process(summary, true),
    summary: summary,
    content: content,
    ttl: "#{(Time.now - @start).round(3)} sec"
  }.to_json
end
