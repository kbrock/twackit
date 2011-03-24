Factory.define :twitterer do |f|
  f.sequence(:username) { |n| "twitterer#{n}" }
  f.sequence(:full_name) { |n| "Twitterer #{n}" }
  f.picture_url { |t| "#{t.username}.jpg" }
end

Factory.define :tweet do |f|
  f.sequence(:status_id) { |n| "#{n}"}
  f.status_at { Time.now }
end

Factory.define :status, :class => 'Mash', :default_strategy => :build do |t|
  t.id 1
  t.created_at Time.utc(2009, 4, 29, 19, 6, 33)
  t.from_user 'doctorzaius'
  t.iso_language_code 'en'
end
