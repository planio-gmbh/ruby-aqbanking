
module AqBanking
  class Account
    ACCOUNTS = YAML.load_file(File.join(File.dirname(__FILE__), '..','..', 'config', 'accounts.yaml')) unless defined? ACCOUNTS
    attr_accessor :account_id, :bank_code, :user_id, :customer_id, :user_name, :server_url, :hbci_version, :pin



    def initialize(account=nil)
      @hbci_version = 220
      if account.is_a?(String)
        account = ACCOUNTS[account]
      end
      if account
        account.each do |k,v|
          instance_variable_set("@#{k}",v.to_s)
        end
      end
    end

    def build_pin_file
      str = "PIN_#{self.bank_code}_#{self.user_id} = \"#{self.pin}\"\n"
      (File.new("pin","w") << str).close
    end

    def delete_pin_file
      File.delete("pin")
    end

    def ==(other)
      (instance_variables - ["@transaction_request","@balance"]).all? do |v|
        instance_variable_get(v) == other.instance_variable_get(v)
      end
    end


    def transactions(from=nil,to=nil)
      request = AqBanking::Request.new(self,:type=>"transactions",:from=>from,:to=>to)
      unless (@transaction_request == request)
        build_pin_file
        @transaction_request = request
        @transactions = @transaction_request.execute
        delete_pin_file
      end
      @transactions
    end

    def balance
      @balance||= AqBanking::Request.new(self,:type=>"balance").execute
    end

  end
end
