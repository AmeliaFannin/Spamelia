# Wellframe Interview Spam Filter API

I built a Bayesian spam filter deployed to heroku using sinatra.

collect_sample.rb "teaches" the filter with samples of known spam and ham, counting the number of times words appeared in emails and collecting that info in a hash (spam.yaml and ham.yaml).

spamelia.rb receives POST requests of emails and calculates the probabilty of the email being spam based on the spamminess probability of individual words. Spam and Not-Spam thresholds can be adjusted as the filter accuracy improves. API returns "Spam" and "Not-Spam".

utils/spamelia_test.rb sends Post request to api with samples of ham and spam from my recent emails.


### Test it out:
  - run the test script in the utils folder.
  
  - or send your own email sample: 
  curl -X POST --header "Content-Type: application/json" http://spamelia.herokuapp.com/ -d '{"email_text": "Miracle diet cure, send money my dear friend"}'


## Improvements and Next Steps

### Speed & Efficiency:

  - Create a single hash from the spam.yml and ham.yml that stores word-spamminess%.

  - Rather than checking each word in an email for spamminess, check an email for spammy words in order from 99% spam to not-spam. When the filter encounters a certain number of high spamminess words, the email is declared spam.

  - Find more efficient ways to eliminate or skip over non-words in emails during the filter building process.


### Scaling:

  - Keep the spamminess% info on a central server using Redis. Allow multiple servers to access and process post requests.


### Accuracy:
  
  - Implement a feedback system. The user posts wrongly identified emails to the api which triggers re-evaluation and updating of the spamminess hash.

  - Add heuristics -- check for signature spam things like all caps or !!!!

  - Use email or IP address blacklists. 

  - Use a natural language processor to analyse sentiment rather than treating words as independent events.





###Problem

Design and implement an API for an on-demand spam filter system. For the spam filtering and classification, use any technique you like. You can use an algorithm from the literature, or implement your own. A user should be able to submit a set of messages via the API and the should receive a list stating which messages are spam and which messages are not.

### Design

We would also like to know how this system performs at scale. What kind of infrastructure and system design choices would you make? How would you scale servers? Is your filter real-time, or a batch process that runs hourly, daily, or weekly, etc. How does your system handle server failures, cache failures, etc? If you build a distributed system, how do you update your model? What trade offs are made?

### Coding

Build an MVP (minimum viable product) of this API and make it publicly accessible (AWS or Heroku). It should be able to take in emails and return the appropriate results. After you implement your algorithm, what kind of false positive/false negative rates are you able to obtain?

Feel free to make reasonable assumptions. For training/test data, you can use SpamAssassin's public corpus of sample ham and spam emails — https://spamassassin.apache.org/publiccorpus/

