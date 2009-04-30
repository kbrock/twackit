Factory.define :twitterer do |f|
  f.sequence(:username) { |n| "twitterer#{n}" }
  f.sequence(:full_name) { |n| "Twitterer #{n}" }
  f.picture_url { |t| "#{t.username}.jpg" }
end

Factory.define :tweet do |f|
  f.sequence(:status_id) { |n| "#{n}"}
  f.status_at { Time.now }
end
