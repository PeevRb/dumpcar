require "spec_helper"

RSpec.shared_context "db_config from hash" do
  let(:db_config) {
    {
      database: "dumpcar_test",
      password: "postgres",
      username: "postgres"
    }
  }

  subject { described_class.new(db_config) }
end

RSpec.shared_context "db_config from hash config" do
  let(:db_config) { ActiveRecord::DatabaseConfigurations::HashConfig.new("development", "test", {}) }

  subject { described_class.new(db_config) }
end

RSpec.shared_context "db_config from url config" do
  let(:db_config) { ActiveRecord::DatabaseConfigurations::UrlConfig.new("development", "test", "postgres://postgres:postgres@localhost/dumpcar_test", {}) }

  subject { described_class.new(db_config) }
end

RSpec.describe Dumpcar::Util::DatabaseConfiguration do
  describe "#connection_type" do
    context "db_config from hash" do
      include_context "db_config from hash"
      it { is_expected.to have_attributes(connection_type: :unknown) }
    end

    context "db_config from hash config" do
      include_context "db_config from hash config"
      it { is_expected.to have_attributes(connection_type: :hash) }
    end

    context "db_config from url config" do
      include_context "db_config from url config"
      it { is_expected.to have_attributes(connection_type: :url) }
    end
  end

  describe "#configuration_hash" do
    context "db_config from hash" do
      include_context "db_config from hash"
      it { is_expected.to have_attributes(configuration_hash: an_instance_of(Hash)) }
    end

    context "db_config from hash config" do
      include_context "db_config from hash config"
      it { is_expected.to have_attributes(configuration_hash: an_instance_of(Hash)) }
    end

    context "db_config from url config" do
      include_context "db_config from url config"
      it { is_expected.to have_attributes(configuration_hash: an_instance_of(Hash)) }
    end
  end
end
