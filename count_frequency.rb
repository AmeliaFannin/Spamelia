require 'yaml'

class Spammer

  def initialize(word)
    @ham = YAML::load_file "ham.yml"
    @spam = YAML::load_file "spam.yml"

    calc_spamminess(word)
  end

  def calc_spamminess(word)
    word = word.downcase
    ham = @ham[0]
    ham_size = @ham[1]

    spam = @spam[0]
    spam_size = @spam[1]

    total_sample = (ham_size.to_f + spam_size.to_f)
    spam_word = spam.fetch(word, 0).to_f
    total_word = ham.fetch(word, 0).to_f + spam_word

    num = (spam_word / total_word) * (total_word / total_sample) 
    denom = (total_word * total_sample )
    percent_spammy = (num / denom) 

    puts "#{word} is #{percent_spammy * 100}% spammy"
  end
end


  Spammer.new('free')
  Spammer.new('drugs')


