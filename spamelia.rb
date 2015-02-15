require 'yaml'


def calc_spamminess(word)
  @ham = YAML::load_file "ham.yml"
  @spam = YAML::load_file "spam.yml"

    # [0] = the hash [1] = size of sample
    # word = word.downcase

    # total num of spam emails
    spam_emails = @spam[1]

    # total num of emails
    total_emails = (@ham[1] + @spam[1])

    
    # num of spam emails containing spam word
    spam_word = @spam[0].fetch(word, 0)


    # total num of email containing spam word
    total_word = @ham[0].fetch(word, 0) + spam_word

    # (a * b)/c
    a = spam_word / spam_emails.to_f
    
    # b is static
    b = spam_emails / total_emails.to_f

    c = total_word / total_emails.to_f

    percent_spammy = (a * b)/c
    puts "#{word} is #{percent_spammy * 100}% spammy"
    return percent_spammy

    
end

def multi_word_spam
  word1 = calc_spamminess('million')
  word2 = calc_spamminess('work')

  percent = (word1 * word2)/((word1 * word2) + (1 - word1) * (1 - word2))
  puts "million and work is #{percent * 100}% spammy"
end

multi_word_spam