module AqRuby
  class Account
    attr_accessor :account_id, :bank_code, :user_id, :customer_id, :user_name, :server_url, :hbci_version, :pin
    def initialize(account=nil)
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
      str= "# User \"707353189400\" at \"13070024\" \n"
      str << "PIN_#{self.bank_code}_#{self.user_id} = \"#{self.pin}\"\n"
      (File.new("pin","w") << str).close
    end

    def delete_pin_file
      File.delete("pin")
    end

    def transactions(from=nil,to=nil)
      req = AqRuby::Request(self,:type=>"transactions",:from=>from,:to=>to)
      req.execute
      req.process

    end

  end
end
