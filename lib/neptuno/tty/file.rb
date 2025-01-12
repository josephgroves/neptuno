# frozen_string_literal: true

module Neptuno
  module TTY
    # Wrapper class for TTY gem
    module File
      TTY = ::TTY::File
      ABORT_MESSAGE = 'fatal: not a Neptuno repository (or any of the parent directories)'

      def file
        TTY
      end

      # define path helpers
      def project
        neptuno_path.split('/').last
      end

      def in_service?
        Dir.pwd.include?("#{neptuno_path}/services/")
      end

      def service
        ENV['PWD'].match(%r{services/([^/]*)})&.captures&.first
      end

      def neptuno_path
        return @base_path if @base_path

        pwd = Dir.pwd
        loop do
          return pwd if pwd == ''
          return @base_path = pwd if Dir.children(pwd).include?('neptuno.yml')

          pwd = pwd.split('/')[0..-2].join('/')
        end
      end

      def make_service_files(services)
        services.each do |service|
          `cd #{neptuno_path} && mkdir -p environments/#{service} procfiles/#{service} dockerfiles/#{service}`
          `cd #{neptuno_path} && touch environments/#{service}/local_env`
          `cd #{neptuno_path} && touch dockerfiles/#{service}/Dockerfile`
        end
      end
    end
  end
end
