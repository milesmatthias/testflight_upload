require 'rest_client'
require 'json'
require 'tmpdir'
require 'fileutils'
require 'ostruct'

class Testflight
  ENDPOINT = "https://testflightapp.com/api/builds.json"

  def initialize(&block)
    @configuration = OpenStruct.new(
      :ipa_path => nil,
      :zipped_dsym_path => nil,
      :distribution_lists => nil,
      :replace => false,
      :notify_testers => false,
      :user_notification => false,
      :verbose => false,
      :dry_run => false,
      :api_token => nil,
      :team_token => nil,
      :release_notes_text => nil
    )
    yield @configuration if block_given?
  end

  def prepare
    puts "Nothing to prepare!"
  end

  def deploy
    release_notes = get_notes
    payload = {
      :api_token          => @configuration.api_token,
      :team_token         => @configuration.team_token,
      :file               => File.new(@configuration.ipa_path, 'rb'),
      :notes              => release_notes,
      :distribution_lists => (@configuration.distribution_lists || []).join(","),
      :notify             => @configuration.notify || false,
      :replace            => @configuration.replace || false,
      :dsym               => File.new(@configuration.zipped_dsym_path, 'rb')
    }
    puts "Uploading build to TestFlight..."
    if @configuration.verbose
      puts "ipa path: #{@configuration.ipa_path}"
      puts "release notes: #{release_notes}"
      puts "payload = ", payload
    end
    
    if @configuration.dry_run 
      puts '** Dry Run - No action here! **'
      return
    end
    
    begin
      response = RestClient.post(ENDPOINT, payload, :accept => :json)
      puts "response = ", response
    rescue => e
      response = e.response
    end
    
    if (response.code == 201) || (response.code == 200)
      puts "Upload complete."
      if @configuration.user_notification
        system "terminal-notifier -title 'Testflight Upload' -message 'Upload completed successfully.' -sound default"
      end
    else
      puts "Upload failed. (#{response})"
      if @configuration.user_notification
        system "terminal-notifier -title 'Testflight Upload' -message 'Upload failed with message: #{response}' -sound default"
      end
    end
  end
  
  private
  
  def get_notes
    notes = @configuration.release_notes_text
    notes || get_notes_using_editor || get_notes_using_prompt
  end
  
  def get_notes_using_editor
    return unless (editor = ENV["EDITOR"])

    dir = Dir.mktmpdir
    begin
      filepath = "#{dir}/release_notes"
      system("#{editor} #{filepath}")
      @configuration.release_notes = File.read(filepath)
    ensure
      FileUtils.rm_rf(dir)
    end
  end
  
  def get_notes_using_prompt
    puts "Enter the release notes for this build (hit enter twice when done):\n"
    @configuration.release_notes = gets_until_match(/\n{2}$/).strip
  end

  def gets_until_match(pattern, string = "")
    if (string += STDIN.gets) =~ pattern
      string
    else
      gets_until_match(pattern, string)
    end
  end
end
