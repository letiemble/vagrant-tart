# frozen_string_literal: true

require "open3"

module VagrantPlugins
  # Top level module for the Tart provider plugin.
  module Tart
    # Path to the version file.
    VERSION_FILE = "#{File.dirname(__FILE__)}/version".freeze

    # Get the version of the plugin:
    # - If the version file exists, read it
    # - If the version file does not exist, and the plugin is in a git repository, read the tag
    # - If the version is not available, return "0.0.0"
    def self.version
      version = if File.exist?(VERSION_FILE)
                  File.read(VERSION_FILE)
                elsif inside_git_repository
                  git_describe
                end

      version ||= "0.0.0"
      version.freeze
    end

    # Set the version of the plugin.
    def self.set_version
      File.write(VERSION_FILE, version)
    end

    # Check if the plugin is inside a git repository.
    def self.inside_git_repository
      _, status = Open3.capture2e("git rev-parse --git-dir")
      status.success?
    end

    # Get the current tag.
    def self.git_describe
      tag, status = Open3.capture2e("git describe --tags")
      tag.chomp if status.success?
    end
  end
end
