module APN2
  module Connection

    def connection_pool
      @pool ||= ConnectionPool.new(size: (pool_size || 1), timeout: (pool_timeout || 5)) do
        APN2::Client.new(host: host,
                        port: port,
                        certificate: certificate,
                        password: password)
      end
    end

    def with_connection(&block)
      connection_pool.with(&block)
    end

    def reset_connection
      connection_pool.with do |client|
        client.send(:reset_socket)
      end
    end

    # pool config
    attr_accessor :pool_size, :pool_timeout

    attr_accessor :host, :port, :root, :full_certificate_path, :password

    def certificate
      @apn_cert ||= File.read(certificate_path)
    end

    def certificate_path
      full_certificate_path || File.join(root, certificate_name)
    end

    def certificate_name
      @cert_name || "apn_production.pem"
    end

    def certificate_name=(name)
      @cert_name = name
    end
  end
end
