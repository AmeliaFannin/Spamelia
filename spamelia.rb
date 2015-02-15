require 'yaml'


def calc_spamminess(word)
  @ham = YAML::load_file "ham.yml"
  @spam = YAML::load_file "spam.yml"

    # [0] = the hash [1] = size of sample
    word = word.downcase

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
    
    b = spam_emails / total_emails.to_f

    c = total_word / total_emails.to_f

    percent_spammy = (a * b)/c
    
    puts "#{word} is #{percent_spammy * 100}% spammy"
    return percent_spammy   
end

def multi_word_spam(message)
  p_array = []
  stopwords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]
  likelyhood = 0


  message.force_encoding("iso-8859-1").gsub!(/ <.*> /, '')
    # removes most email addresses
  message.gsub!(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, '')
    # removes punctuation
  message.gsub!(/ [[:punct:]] /, ' ')
    # remove number/letter "words"
  message.gsub!(/\w+\d+/, ' ')
    #removes characters
  message.gsub!(/\W/, ' ')
        
  message.split(' ').each do |w|

    next if w.length < 3 || w.length > 15 || stopwords.include?(w)
    w.downcase!
    pr = calc_spamminess(w)

    pr = 0.99 if pr == 1.0
    p_array << pr   
    
    if p_array.length > 1
      percent = p_array.reduce(:*)/ (p_array.reduce(:*) + p_array.map {|p| 1 - p.to_f}.reduce(:*))
      puts percent
      if percent >= 0.90
        likelyhood = percent
        break
      end
    end
  end
  

  puts "message is #{likelyhood * 100}% likely spammy"
end

test_message = <<HEREDOC
  Dear Friend:

Find solutions to all your daily problems and life's challenges at the click of a mouse button?

We have the answers you're looking for on The Word Bible CD-ROM it is one of the most powerful, life-changing tools available today and it's easy to use.

On one CD, (Windows or Macintosh versions) you have a complete library of Bibles, well known reference books and study tools. You can view several Bible versions simultaneously, make personal notes, print scriptures and search by word, phrase or topic.

The Word Bible CD offers are simply amazing.

The wide range of resources on the CD are valued at over $1,500 if purchased separately.

** 14 English Bible Versions
** 32 Foreign Language Versions
** 9 Original Language Versions
** Homeschool Resource Index
** 17 Notes & Commentaries
** Colorful Maps, Illustrations, & Graphs
** Step-by-Step Tutorial
** Fast & Powerful Word/Phrase Search
** More than 660,000 cross references
** Complete Manual With Index

Also:

** Build a strong foundation for dynamic Bible Study,
** Make personal notes directly into your computer,
** Create links to favorite scriptures and books.


Try it. No Risk. 30-day money-back guarantee
[excluding shipping & handling]

If you are interested in complete information on The Word CD, please visit our
Web site: http://bible.onchina.net/ 

US and International orders accepted. Credit cards and personal checks accepted.

If your browser won't load the Web site please click the link below to send us an e-mail and we will provide you more information.

mailto:bible-cd@minister.com?subject=Please-email-Bible-info   

Your relationship with God is the foundation of your life -- on earth and for eternity. It's the most important relationship you'll ever enjoy. Build your relationship with God so you can reap the life-changing benefits only He can provide: unconditional love; eternal life; financial and emotional strength; health; and solutions to every problem or challenge you'll ever face.

May God Bless You,
GGII Ministries, 160 White Pines Dr., Alpharetta Ga, 30004
E-mail address:Bible-CD@minister.com 
Phone:  770-343-9724
HEREDOC

multi_word_spam(test_message)
