require "fastlane_core"
require "credentials_manager"

module Scan
  class Options
    def self.available_options
      return @options if @options

      @options = plain_options
    end

    def self.plain_options
      [
        FastlaneCore::ConfigItem.new(key: :workspace,
                                     short_option: "-w",
                                     env_name: "SCAN_WORKSPACE",
                                     optional: true,
                                     description: "Path the workspace file",
                                     verify_block: proc do |value|
                                       v = File.expand_path(value.to_s)
                                       raise "Workspace file not found at path '#{v}'".red unless File.exist?(v)
                                       raise "Workspace file invalid".red unless File.directory?(v)
                                       raise "Workspace file is not a workspace, must end with .xcworkspace".red unless v.include?(".xcworkspace")
                                     end),
        FastlaneCore::ConfigItem.new(key: :project,
                                     short_option: "-p",
                                     optional: true,
                                     env_name: "SCAN_PROJECT",
                                     description: "Path the project file",
                                     verify_block: proc do |value|
                                       v = File.expand_path(value.to_s)
                                       raise "Project file not found at path '#{v}'".red unless File.exist?(v)
                                       raise "Project file invalid".red unless File.directory?(v)
                                       raise "Project file is not a project file, must end with .xcodeproj".red unless v.include?(".xcodeproj")
                                     end),
        FastlaneCore::ConfigItem.new(key: :scheme,
                                     short_option: "-s",
                                     optional: true,
                                     env_name: "SCAN_SCHEME",
                                     description: "The project's scheme. Make sure it's marked as `Shared`"),
        FastlaneCore::ConfigItem.new(key: :clean,
                                     short_option: "-c",
                                     env_name: "SCAN_CLEAN",
                                     description: "Should the project be cleaned before building it?",
                                     is_string: false,
                                     default_value: false),
        # FastlaneCore::ConfigItem.new(key: :output_directory,
        #                              short_option: "-o",
        #                              env_name: "SCAN_OUTPUT_DIRECTORY",
        #                              description: "The directory in which the ipa file should be stored in",
        #                              default_value: "."),
        FastlaneCore::ConfigItem.new(key: :buildlog_path,
                                     short_option: "-l",
                                     env_name: "SCAN_BUILDLOG_PATH",
                                     description: "The directory were to store the raw log",
                                     default_value: "~/Library/Logs/scan"),
        FastlaneCore::ConfigItem.new(key: :sdk,
                                     short_option: "-k",
                                     env_name: "SCAN_SDK",
                                     description: "The SDK that should be used for building the application",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :configuration,
                                     short_option: "-q",
                                     env_name: "SCAN_CONFIGURATION",
                                     description: "The configuration to use when building the app. Defaults to 'Release'",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :silent,
                                     short_option: "-a",
                                     env_name: "SCAN_SILENT",
                                     description: "Hide all information that's not necessary while building",
                                     default_value: false,
                                     is_string: false),
        FastlaneCore::ConfigItem.new(key: :destination,
                                     short_option: "-d",
                                     env_name: "SCAN_DESTINATION",
                                     description: "Use a custom destination for building the app",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :xcargs,
                                     short_option: "-x",
                                     env_name: "SCAN_XCARGS",
                                     description: "Pass additional arguments to xcodebuild. Be sure to quote the setting names and values e.g. OTHER_LDFLAGS=\"-ObjC -lstdc++\"",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :xcconfig,
                                     short_option: "-y",
                                     env_name: "SCAN_XCCONFIG",
                                     description: "Use an extra XCCONFIG file to build your app",
                                     optional: true,
                                     verify_block: proc do |value|
                                       raise "File not found at path '#{File.expand_path(value)}'".red unless File.exist?(value)
                                     end)
      ]
    end
  end
end
