Gem::Specification.new do |s|
  s.name = "testflight_upload"
  s.version = "0.0.1"
  s.authors = "Miles Matthias"
  s.email = "miles.matthias@gmail.com"
  s.homepage = "https://github.com/milesmatthias/testflight_upload"
  s.date = "2013-09-04"
  s.summary = "A simple Testflight uploader for when you already have everything built and archived."
  s.description = "A simple Testflight uploader for when you already have everything built and archived."
  s.add_dependency(%q<rest-client>, ["~> 1.6.1"])
  s.add_dependency(%q<json>, [">= 0"])
end
