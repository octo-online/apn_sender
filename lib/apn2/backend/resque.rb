begin
  require 'resque'
  require 'apn2/jobs/resque_notification_job'
rescue LoadError => e
  $stderr.puts "You don't have resque installed in your application. Please add it to your Gemfile and run bundle install"
  raise e
end

module APN2
  module Backend
    class Resque
      def notify(token, opts)
        ::Resque.enqueue(APN2::Jobs::ResqueNotificationJob, token, opts)
      end
    end
  end
end
