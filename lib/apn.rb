require "openssl"
require "socket"
require "active_support/core_ext"
require "active_support/json"
require 'connection_pool'

require "apn2/version"
require 'apn2/connection'

module APN2

  class << self
    include APN2::Connection

    def notify_async(token, opts = {})
      token = token.to_s.gsub(/\W/, '')
      backend.notify(token, opts)
    end

    def notify_sync(token, opts)
      token = token.to_s.gsub(/\W/, '')
      msg = APN2::Notification.new(token, opts)
      raise "Invalid notification options (did you provide :alert, :badge, or :sound?): #{opts.inspect}" unless msg.valid?

      APN2.with_connection do |client|
        client.push(msg)
      end
    end

    def backend=(backend)
      @backend =
        case backend
        when Symbol
          APN2::Backend.const_get(backend.to_s.camelize).new
        when nil
          APN2::Backend::Simple.new
        else
          backend
        end
    end

    def backend
      @backend ||= APN2::Backend::Simple.new
    end

    def logger=(logger)
      @logger = logger
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def truncate_alert
      @truncate_alert ||= false
    end

    def truncate_alert=(truncate)
      @truncate_alert = truncate
    end

    # Log message to any logger provided by the user (e.g. the Rails logger).
    # Accepts +log_level+, +message+, since that seems to make the most sense,
    # and just +message+, to be compatible with Resque's log method and to enable
    # sending verbose and very_verbose worker messages to e.g. the rails logger.
    #
    # Perhaps a method definition of +message, +level+ would make more sense, but
    # that's also the complete opposite of what anyone comming from rails would expect.
    def log(level, message = nil)
      level, message = 'info', level if message.nil? # Handle only one argument if called from Resque, which expects only message

      return false unless logger && logger.respond_to?(level)
      logger.send(level, "#{Time.now}: #{message}")
    end

    # Log the message first, to ensure it reports what went wrong if in daemon mode.
    # Then die, because something went horribly wrong.
    def log_and_die(msg)
      logger.fatal(msg)
      raise msg
    end
  end
end

require 'apn2/notification'
require 'apn2/client'
require 'apn2/feedback'

module APN2::Jobs
  QUEUE_NAME = :apple_push_notifications
end

require "apn2/railtie" if defined?(Rails)
require 'apn2/backend'
