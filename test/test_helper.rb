require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"

require_relative "helpers/testcontainers"

postgres = Testcontainers::PostgreSQL.start
postgres.wait_for_logs(/database system is ready to accept connections/)

ENV["TEST_DATABASE_HOST"] = postgres.host
ENV["TEST_DATABASE_PORT"] = postgres.mapped_port(5432).to_s
ENV["TEST_DATABASE_NAME"] = "myapp_test"
ENV["TEST_DATABASE_USER"] = "postgres"
ENV["TEST_DATABASE_PASSWORD"] = "postgres"


require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    fixtures :all
  end
end
