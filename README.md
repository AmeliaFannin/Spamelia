Wellframe Interview Spam Filter API

Problem

Design and implement an API for an on-demand spam filter system. For the spam filtering and classification, use any technique you like. You can use an algorithm from the literature, or implement your own. A user should be able to submit a set of messages via the API and the should receive a list stating which messages are spam and which messages are not.

Design

We would also like to know how this system performs at scale. What kind of infrastructure and system design choices would you make? How would you scale servers? Is your filter real-time, or a batch process that runs hourly, daily, or weekly, etc. How does your system handle server failures, cache failures, etc? If you build a distributed system, how do you update your model? What trade offs are made?

Coding

Build an MVP (minimum viable product) of this API and make it publicly accessible (AWS or Heroku). It should be able to take in emails and return the appropriate results. After you implement your algorithm, what kind of false positive/false negative rates are you able to obtain?

Feel free to make reasonable assumptions. For training/test data, you can use SpamAssassin's public corpus of sample ham and spam emails — https://spamassassin.apache.org/publiccorpus/


I built a basic Bayesian spam filter. 

collect_sample.rb -- "teaches" the filter with samples of known spam and ham, crudely counting the number of times words appeared in emails and collecting that info in a hash (spam.yaml and ham.yaml)

spamelia.rb -- receives POST requests of unknown emails, calculates the probabilty of the email being spam based on the spamminess probability of individual words. Spam and Not-Spam thresholds can be adjusted as the filter accuracy improves. Returns status code 200 for spam, code 400 for not-spam.

utils/spamelia_test.rb -- Sends Post request to api with samples of ham and spam from my recent emails, interpret status code responses

the project is deployed to heroku using sinatra

