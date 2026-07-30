require "testcontainers"

module Testcontainers
  module PostgreSQL
    def self.start
      container = Testcontainers::DockerContainer.new("postgres:16-alpine")

      container.with_env(
        "POSTGRES_USER" => "postgres",
        "POSTGRES_PASSWORD" => "postgres",
        "POSTGRES_DB" => "myapp_test"
      )

      container.with_exposed_port(5432)
      container.start

      container
    end
  end
end
