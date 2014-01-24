module APN2
  module Backend
    autoload :Sidekiq,     'apn2/backend/sidekiq'
    autoload :Resque,      'apn2/backend/resque'

    class Simple
      def notify(token, opts)
        Thread.new do
          APN2.notify_sync(token, opts)
        end
      end
    end

    class Null
      def notify(token, opts)
        APN2.log("Null Backend sending message to #{token}")
      end
    end
  end
end
