Factory.define :twitterer do |f|
  f.sequence(:username) { |n| "twitterer#{n}" }
  f.sequence(:full_name) { |n| "Twitterer #{n}" }
  f.picture_url { |t| "#{t.username}.jpg" }
end

Factory.sequence :status_id do |n|
  "#{n}"
end
Factory.define :tweet do |f|
  f.status_id { Factory.next(:status_id) }
  f.status_at { Time.now }
end

Factory.define :status, :class => 'Mash', :default_strategy => :build do |t|
  t.id { Factory.next(:status_id) }
  t.created_at { Time.utc(2009, 4, 29, 19, 6, 33) }
  t.from_user 'doctorzaius'
  t.iso_language_code 'en'
end
