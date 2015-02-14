
def get_sample
  input = []

  Dir.foreach("#{Dir.pwd}/spam/") do |name|
    next if name == '.' or name == '..' or name == 'cmds'
    # puts name

    File.open "#{Dir.pwd}/spam/#{name}", "r" do |f|
      f.each_line do |l|
        input << l
      end
    end
  end

  return input
end

def count_frequency
  words = {}

  get_sample.each do |s|
    # removes non UTF-8 characters
    s.force_encoding("iso-8859-1").gsub!(/\W/, ' ')

    # removes most email addresses
    s.gsub!(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, '')

    # removes html tags, punctuation, numbers
    s.gsub!(/[ <.*> [[:punct:]] [[:digit:]] ]/, ' ')


    s.split(' ').each do |w|

      if w.length > 3
        if words.has_key?(w)
          words[w] += 1
        else 
          words[w] = 1
        end
      end
    end
  end

  words
end

puts count_frequency


