require "spec_helper"

def pending_rails_version?
  Rails.version >= "6.1" && Rails.version < "7.1"
end

RSpec.describe "Console", type: :aruba, pending: pending_rails_version? ? "This strangely fails on Rails 6.1 and 7" : false do
  let(:working_dir) { ArubaWorkingDirectory.new }

  def rails_command(dumpcar_commands)
    "bundle exec rails " + dumpcar_commands
  end

  def prepare_working_dir
    working_dir.mkdir_p
    working_dir.copy_all_from(Rails.root.join("db/dumps"))
  end

  around(:each, type: :aruba) do |ex|
    bundle_file = ENV["BUNDLE_GEMFILE"]
    Bundler.with_unbundled_env do
      prepare_working_dir
      if bundle_file
        set_environment_variable("BUNDLE_GEMFILE", bundle_file)
      end
      ex.run
    end
  end

  describe ":dump" do
    context "with base_dir" do
      it "puts things in a different base_folder" do
        base_dir = Pathname.new(Rails.root).join("tmp", "base_folder" + Random.uuid)

        SimpleObject.create(name: "so-1")
        run_command(rails_command("dumpcar:dump --base_dir=" + base_dir.to_s))

        expect(last_command_started).to be_successfully_executed

        SimpleObject.delete_all

        expect(SimpleObject).to be_none

        expect(base_dir.children.count).to eq 1
      end
    end

    context "with passed name" do
      [
        "--description",
        "--desc"
      ].each do |arg|
        it "generates a dump name properly and can round trip with '#{arg}'" do
          description = "This is a  VALID Description"

          SimpleObject.create(name: "so-1")
          run_command(rails_command("dumpcar:dump #{arg}='#{description}'"))
          expect(last_command_started).to be_successfully_executed
          SimpleObject.delete_all

          expect(SimpleObject).to be_none

          expect(working_dir.pathname.children.last.basename.to_s).to be_end_with "-this-is-a-valid-description.dump"
          run_command(rails_command("dumpcar:load"))

          expect(SimpleObject.count).to eq 1
        end
      end
    end
  end

  describe ":restore" do
    it "restores the last dump by default" do
      expect(SimpleObject).to be_none

      run_command(rails_command("dumpcar:restore"))
      expect(last_command_started).to be_successfully_executed

      expect(SimpleObject.count).to eq 3
    end

    it "overwrites any changes" do
      expect(SimpleObject).to be_none

      SimpleObject.create(name: "should-not-be here")

      run_command(rails_command("dumpcar:restore"))
      expect(last_command_started).to be_successfully_executed

      expect(SimpleObject.count).to eq 3

      expect(SimpleObject.where(name: "should-not-be here")).to be_none
    end
  end
end
