# frozen_string_literal: true

module Neptuno
  module Docker
    # Build docker container for Neptuno project
    class Build < Neptuno::CLI::Base
      desc "Docker: Build docker containers for project"

      option :all, type: :boolean, default: false, desc: "Run on all services"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("build", all: options.fetch(:all), services_as_args: services) do |services|
          system("docker compose build #{services.join(" ")} --parallel")
        end
      end
    end
  end
end