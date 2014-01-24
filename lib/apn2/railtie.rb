module APN2
  class Railtie < Rails::Railtie
    initializer "apn.setup" do |app|

      APN2.root = File.join(Rails.root, "config", "certs")
      if Rails.env.development?
        APN2.certificate_name =  "apn_development.pem"
        APN2.host =  "gateway.sandbox.push.apple.com"
      end

      logger = Logger.new(File.join(Rails.root, 'log', 'apn_sender.log'))
      APN2.logger = logger

    end
  end
end
