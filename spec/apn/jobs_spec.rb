require 'spec_helper'

if defined? Sidekiq
  require 'apn2/backend/sidekiq'
  describe APN2::Jobs::SidekiqNotificationJob do

    it { should be_a(Sidekiq::Worker) }

    it "has the right queue name" do
      expect(subject.class.instance_variable_get(:@queue)).to eq(APN2::Jobs::QUEUE_NAME)
    end
  end
end

if defined? Resque
  require 'apn2/backend/resque'
  describe APN2::Jobs::ResqueNotificationJob do

    it "has the right queue name" do
      expect(subject.class.instance_variable_get(:@queue)).to eq(APN2::Jobs::QUEUE_NAME)
    end
  end
end
