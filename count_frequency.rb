require 'yaml'

class Spammer

  def initialize(word)
    @ham = YAML::load_file "ham.yml"
    @spam = YAML::load_file "spam.yml"

    calc_spamminess(word)
  end

  def calc_spamminess(word)

    # [0] = the hash [1] = size of sample
    word = word.downcase

    total_sample = (@ham[1] + @spam[1])
    spam_word = @spam[0].fetch(word, 0)
    total_word = @ham[0].fetch(word, 0) + spam_word

    num = (spam_word / total_word.to_f) * (total_word / total_sample.to_f) 
    denom = (total_word * total_sample.to_f )
    percent_spammy = (num / denom) 
    puts num
    puts denom

    puts "#{word} is #{percent_spammy}% spammy"
  end
end


  Spammer.new('free')
  Spammer.new('drugs')


