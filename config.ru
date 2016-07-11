require './app'
require './constants/stop_words'
require './constants/sentiment_words'

x = {}
SENTI_HASH.map{|k,v| x[k.stem] = v }
SENTI_STEM_HASH = x

run Sinatra::Application
