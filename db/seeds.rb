require 'factory_girl'
require File.dirname(__FILE__) + '/../test/factories.rb'

(1..100).each do |i|
  tweet = Tweet.build_for_status Factory(:status,
    :id => 1000 + i,
    :from_user => 'doctorzaius',
    :text => "@twackit #{150 + (rand * 50).to_i} #{i.days.ago.to_s(:mdy)} #weight"
  )
  tweet.save!

  tweet = Tweet.build_for_status Factory(:status,
    :id => (2000 + i),
    :from_user => 'kbrock',
    :text => "@twackit #{150 + (i/2)} #{i.days.ago.to_s(:mdy)} #weight"
  )
  tweet.save!
end
  