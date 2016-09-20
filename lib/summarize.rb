# uses summarize gem to provide summary input is article
class Summarize
  attr_reader :text

  def initialize
    @percent = 25
  end

  def process(text)
    @text  = text
    @text = @text.to_s.scrub
    scored =  OTS.parse(@text).summarize(percent: 100)
    scored.reject!{|s| s[:sentence].length > 1000 }
    #sentences = scored.map { |x| x[:sentence] }
    scores = scored.map {|x| x[:score]}.sort.reverse
    percentile = (scores.length * (@percent/100.0) ).ceil
    cutoff = scores.take(percentile).last

    scored.reject!{|s| s[:score] < cutoff }
    sentences = scored.map { |x| x[:sentence] }

    summary = sentences.take(6).join(' ')
    summary.gsub!(/\n\n/, ' ')
    summary = summary.scrub.squeeze(' ')
    return summary
  rescue => e
    return @text
  end

  def topics(text)
    @text  = text
    @text = @text.to_s.scrub
    OTS.parse(@text).topics.take(4)
  end
end
