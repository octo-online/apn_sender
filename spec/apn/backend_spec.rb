require 'spec_helper'
describe APN2::Backend do

  context "when not setting any backend" do

    it "is a simple backend" do
      expect(APN2.backend).to be_a(APN2::Backend::Simple)
    end
  end

  context "when setting a nil backend" do

    before do
      APN2.backend = nil
    end

    it "is a simple backend" do
      expect(APN2.backend).to be_a(APN2::Backend::Simple)
    end
  end

  if defined? Sidekiq
    context "when setting a sidekiq backend" do

      before do
        APN2.backend = :sidekiq
      end

      it "is a simple backend" do
        expect(APN2.backend).to be_a(APN2::Backend::Sidekiq)
      end
    end
  end

  if defined? Resque
    context "when setting a resque backend" do

      before do
        APN2.backend = :resque
      end

      it "is a simple backend" do
        expect(APN2.backend).to be_a(APN2::Backend::Resque)
      end
    end
  end
end
