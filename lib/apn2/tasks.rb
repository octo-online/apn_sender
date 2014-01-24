# Slight modifications from the default Resque tasks
namespace :apn do
  task :setup
  task :work => :sender
  task :workers => :senders

  desc "Start an APN2 worker"
  task :sender => :setup do
    require 'apn'

    unless defined?(Resque)
      puts "This rake task is only for resque workers"
      return
    end

    APN2.backend = :resque
    APN2.password = ENV['CERT_PASS']
    APN2.full_certificate_path =  ENV['FULL_CERT_PATH']
    APN2.logger = Rails.logger

    worker = ::Resque::Worker.new(APN2::Jobs::QUEUE_NAME)

    puts "*** Starting worker to send apple notifications in the background from #{worker}"

    worker.work(ENV['INTERVAL'] || 5) # interval, will block
  end

  desc "Start multiple APN2 workers. Should only be used in dev mode."
  task :senders do
    threads = []

    ENV['COUNT'].to_i.times do
      threads << Thread.new do
        system "rake apn:work"
      end
    end

    threads.each { |thread| thread.join }
  end
end
