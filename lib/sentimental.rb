class Sentimental
  def convert_score_to_label(score)
    r = :Neutral
    if score >= 0.002
      r = :Positive
    elsif score <= -0.002
      r = :Negative
    end
    return r
  end

  def process(title, stem = false)
    title = shrink(title)
    sentiment_total = 0.0
    tokens = tokenize(title)
    tokens = stem(tokens) if stem
    tokens += create_bigrams(tokens)
    count = 0.0
    tokens.each do |token|
      if stem
        val = SENTI_STEM_HASH[token] || 0.0
      else
        val = SENTI_HASH[token] || 0.0
      end
      sentiment_total += val
      count += 1.0 if val != 0.0
    end

    sentiment_total = (sentiment_total / count )  if count > 0.0
    return convert_score_to_label(sentiment_total.round(3))
  end


  def tokenize(title)
    title.to_s.downcase.split(/[\s\!\?\.,]+/)
  end

  def stem(tokens)
    tokens.map(&:stem)
  end

  def create_bigrams(tokens)
    bigram = []
    tokens.each_cons(2).to_a.each{|x| bigram.push x.join(" ")}
    return bigram
  end

  def shrink(title)
    title = title.split(/- .+[Nn][Ee][Ww][Ss]$/)[0]
    title = title.split(/http:.+ From Twitter$/)[0]
    title = title.split(/- [Yy]ahoo!/)[0]
    title = title.split(/\(.{2,10}\)$/)[0]
    title = title.split(/http:.+ From Twitter$/)[0]
    title.gsub!(/[^A-Za-z0-9]/, ' ').sub(/\|.+/ , '')
    title = title.downcase
    title = title.split.delete_if{ |x| STOP_WORDS[x] }.join(' ')
    title.gsub!(/ .{1} /,' ')
    return title
  rescue => e
    puts e
    puts title
    return title
  end
end
