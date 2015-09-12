require 'highline/import'

# Modify wakatime API URL in plugins
#   - ~/.yadr/vim/bundle/vim-wakatime/plugin/packages/base.py
#  - ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/WakaTime.xcplugin/Contents/Resources/wakatime-master/wakatime/
module Wakawaka
  class Setup
    WAKATIME_FILES_PATH_PATTERNS = %w(wakatime/base.py wakatime/main.py)
    WAKATIME_URL = 'https://wakatime.com/api/v1/heartbeats'
    WAKAWAKA_PATH = '/wakatime_heartbeat'

    def self.install
      replacement_domain = ask_for_replacement_domain
      if replacement_domain.nil? || replacement_domain.length == 0
        puts 'Doing nothing. Wakawaka setup: out!'
        return
      end

      # TODO: ignore .bak files!
      replacement_url = "#{replacement_domain}#{WAKAWAKA_PATH}"
      wakatime_files_to_override.each do |file|
        override_wakatime_file(file, replacement_url)
      end
    end

    def self.uninstall
      wakatime_files_to_override.each do |file|
        if !file_contain_wakatime_url?(file)
          bak_file = "#{file}.bak"
          if File.exists?(bak_file)
            command = "mv '#{bak_file}' '#{file}'"
            run_command(command)
            puts "Replaced #{file} with #{bak_file}"
          else
            puts "Backup file is not present. You will have to uninstall manually."
          end
        else
          puts "File #{file} contains the Wakatime URL, no need to uninstall there."
        end
      end
    end

    private

    # Searching wakatime/base.py and wakatime/main.py files,
    # ignorying .pyc and .bak files.
    def self.wakatime_files_to_override
      puts "Searching wakatime/base.py and wakatime/main.py files"
      WAKATIME_FILES_PATH_PATTERNS.map do |pattern|
        command = "find ~ -path *#{pattern}*|grep -v .pyc|grep -v .bak"
        run_command(command).split("\n")
      end.flatten
    end

    def self.override_wakatime_file(file, replacement_url)
      if file_contain_wakatime_url?(file)
        puts "Overriding Wakatime file: #{file}, replacing #{WAKATIME_URL} with #{replacement_url}"
        sed_replace_pattern = "s/#{WAKATIME_URL.gsub('/'){'\\\\/'}}/#{replacement_url.gsub('/'){'\\\\/'}}/"
        command = "sed -i .bak #{sed_replace_pattern} '#{file}'"
        run_command(command)
      else
        puts "File #{file} doesn't contain the Wakatime URL. Please uninstall first if you need to change the Wakawaka URL."
      end
    end

    def self.file_contain_wakatime_url?(path)
      command = "cat '#{path}'|grep #{WAKATIME_URL}"
      run_command(command).length > 0
    end

    def self.ask_for_replacement_domain
      puts 'Please enter your Wakawaka domain. If you enter nothing, we\'ll do nothing.'
      ask 'Your domain (no trailing /, for ex. http://wakahack.herokuapp.com): '
    end

    def self.run_command(command)
      #puts "RUN: #{command}"
      `#{command}`
    end
  end
end
