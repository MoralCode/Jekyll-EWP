Gem::Specification.new do |s|
  s.name        = 'JekyllEWP'
  s.version     = '1.0.1'
  s.date        = '2020-01-14'
  s.summary     = "A Jekyll plugin to generate and encrypt PayPal buttons on the fly."
  s.description = "This Jekyll plugin creates paypal Encrypted Web Payments buttons and encrypts them at build time so items in your store cannot have their prices or other attributes changed in Inspect Element"
  s.authors     = ["Adrian Edwards"]
  s.email       = 'adrian@adriancedwards.com'
  s.files       = ["lib/jekyllEWP.rb"]
  s.homepage    = 'https://github.com/MoralCode/Jekyll-EWP'
  s.license       = 'MIT'
end
