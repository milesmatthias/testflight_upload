testflight_upload
=================

Already have everything you need to send to Testflight already built and archived and just need to upload to Testflight in your rake tasks? Use this gem.

syntax
========

```ruby
uploader = Testflight.new do |config|
  config.ipa_path = "HelloWorld.ipa"
  config.zipped_dsym_path = "HelloWorld.app.dSYM.zip"
  config.distribution_lists = [ENV["dist"]]
  config.replace = ENV["replace"]
  config.notify_testers = ENV["notify"]
  config.user_notification = true
  config.verbose = true
  config.api_token = "xxxxxxxx"
  config.team_token = "xxxxxxxx"
end
uploader.deploy()
```

See `example` for a more complete example of how to use this gem.