
def get_sample(type)
  sample = []
  size = 0
  dir_name = type

  Dir.foreach("#{Dir.pwd}/#{dir_name}/") do |name|
    next if name == '.' or name == '..' or name == 'cmds'

    File.open("#{Dir.pwd}/#{dir_name}/#{name}", "r") do |f|
      f.each_line { |l| sample << l }
    end
    size += 1
  end

  return [size, sample]
end

def count_frequency(sample)
  stopwords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]
  hash = {}

  sample.each do |s|
    # removes non UTF-8 characters
    s.force_encoding("iso-8859-1").gsub!(/ <.*> /, '')

    # removes most email addresses
    s.gsub!(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, '')

    # removes punctuation, numbers
    s.gsub!(/[ [[:punct:]] [[:digit:]] ]/, ' ')
    
    s.gsub!(/\W/, ' ')
    s.split(' ').each do |w|
      next if w.length <= 3 || w.length > 15 || stopwords.include?(w)
      
      w.downcase!
      if hash.has_key?(w)
        hash[w] += 1
      else 
        hash[w] = 1
      end
    end
  end

  hash.delete_if {|key, value| value < 2 }
  return hash
end

def calc_spamminess(word) 
  word = word.downcase
  ham = count_frequency( get_sample("easy_ham")[1])
  ham_size = get_sample("easy_ham")[0]

  spam = count_frequency( get_sample("spam")[1])
  spam_size = get_sample("spam")[0]

  total_sample = (ham_size + spam_size).to_f
  spam_word = spam.fetch(word, 0)
  total_word = ham.fetch(word, 0) + spam_word

  puts "#{word} occurs in Spam: #{spam[word]} of #{spam_size}"
  puts "#{word} occurs in Ham: #{ham[word]} of #{ham_size}"


  num = (spam_word / total_sample) 
  denom = (total_word / total_sample)
  percent_spammy = (num / denom) 

  puts percent_spammy
end

calc_spamminess('free')


