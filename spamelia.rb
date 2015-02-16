require 'sinatra'
require 'bundler'
require 'yaml'
require 'json'

post '/' do
  data = JSON.parse request.body.read
  if multi_word_spam(data["email_text"])
    response = ("Spam").to_json
  else
    response = ("Not-Spam").to_json
  end
end

def calc_spamminess(word)
  @ham = YAML::load_file "ham.yml"
  @spam = YAML::load_file "spam.yml"

  # [0] = the hash, [1] = size of sample
  word = word.downcase

  if @spam[0].has_key?(word)
    spam_emails = @spam[1]
    total_emails = (@ham[1] + @spam[1])

    # num of spam emails containing spam word
    spam_word = @spam[0][word]
    
    # total num of emails containing spam word
    total_word = @ham[0].fetch(word, 0.0) + spam_word

    a = spam_word / spam_emails.to_f  
    b = spam_emails / total_emails.to_f
    c = total_word / total_emails.to_f

    percent_spammy = (a * b)/c
      return percent_spammy
    else
      return 0.01
    end
  end
end

def multi_word_spam(message)
  p_array = []
  stopwords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]

  message.force_encoding("iso-8859-1").gsub!(/ <.*> /, ' ')
    # removes most email addresses
  message.gsub!(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, ' ')
    # removes punctuation
  message.gsub!(/ [[:punct:]] /, ' ')
    # remove number/letter "words"
  message.gsub!(/\w+\d+/, ' ')
    #removes characters
  message.gsub!(/\W/, ' ')
  
  message.split(' ').each do |w|
    w.downcase!
    next if w.length <= 3 || w.length > 15 || stopwords.include?(w)
    
    pr = calc_spamminess(w)
    pr = 0.99 if pr == 1.0
    p_array << pr

    if p_array.length > 1
      percent = p_array.reduce(:*)/ (p_array.reduce(:*) + p_array.map {|p| 1 - p.to_f}.reduce(:*))
        
      if percent >= 0.75
        return true
      elsif percent < 0.01
        return false
      end
    end
  end
end