require 'unirest'
require 'json'

def test_the_filter
  
  Dir.foreach("#{Dir.pwd}/test_samples/") do |name|
    next if name == '.' or name == '..' or name == 'cmds'

    input = File.open("#{Dir.pwd}/test_samples/#{name}", "r")

    text = input.read.to_json
    input.close

    # local_host = 'http://127.0.0.1:4567/'

    url = 'http://spamelia.herokuapp.com/'

    response = Unirest.post url,
                            headers:{ "Content-Type" => "application/json" },
                            parameters:{ "email_text" => text }.to_json
    puts name + ": " + response.body 
  end
end

test_the_filter

