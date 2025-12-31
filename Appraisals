[6.0, 6.1, 7.0].each do |ver|
  appraise "rails-#{ver}" do
    gem "rails", "~> #{ver}.0"
    gem "concurrent-ruby", "1.3.4" # concurrent-ruby 1.3.5 has an issue fixed on Rails 7.1+
  end
end

[7.1, 7.2, 8.0, 8.1].each do |ver|
  appraise "rails-#{ver}" do
    gem "rails", "~> #{ver}.0"
  end
end

appraise "rails-edge" do
  gem "rails", github: "rails/rails", branch: "main"
end
