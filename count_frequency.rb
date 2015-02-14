require 'yaml'

class Spammer

  def initialize(word)
    @ham = YAML::load_file "ham.yml"
    @spam = YAML::load_file "spam.yml"

    calc_spamminess(word)
  end

  def calc_spamminess(word)

    # [0] = the hash [1] = size of sample
    # word = word.downcase

    # total num of spam emails
    spam_emails = @spam[1]

    # total num of emails
    total_emails = (@ham[1] + @spam[1])

    
    # num of spam emails containing spam word
    spam_word = @spam[0].fetch(word)


    # total num of email containing spam word
    total_word = @ham[0].fetch(word) + spam_word


    num = (spam_word / spam_emails.to_f) * (spam_emails / total_emails.to_f) 
    denom = (total_word / total_emails.to_f )
    percent_spammy = (num / denom) 

    puts "#{word} is #{percent_spammy * 100}% spammy"
  end
end


  Spammer.new('million')
  Spammer.new('drugs')


