require 'yaml'

module AqBanking
  class Commander

    CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..','..', 'config', 'environment.yaml')) unless defined? CONFIG


    def self.aq_hbci
      CONFIG["aqhbci_tool"]
    end
    def self.aq_cli
      CONFIG["aqbanking_cli"]
    end


    def self.list_balance
      system(self.list_balance_cmd)
    end

    def self.request_balance(account)
      system(self.request_balance_cmd(account))
    end
    def self.request_transactions(account,from=nil,to=nil)
      system(self.request_transactions_cmd(account,from,to))
    end
    def self.process_csv(account)
      system(self.process_csv_cmd(account))
    end

    def self.list_balance_cmd
      cmd =""
      cmd << self.aq_cli
      cmd << " listbal -c result.ctx -o result.csv"
    end

    def self.request_balance_cmd(account)
      self.basic_request_cmd(account) + " --balance"
    end

    def self.request_transactions_cmd(account,from=nil,to=nil)
      cmd =""
      cmd << self.basic_request_cmd(account)
      cmd << " --fromdate=#{from.strftime("%Y%m%d")}" if from
      cmd << " --todate=#{to.strftime("%Y%m%d")}" if to
      cmd << " --transactions"

    end

    def self.basic_request_cmd(account)
      cmd =""
      cmd << self.aq_cli
      cmd << " -P pin request"
      cmd << " -b #{account.bank_code}"
      cmd << " -a #{account.account_id}"
      cmd << " -c result.ctx"
    end

    def self.process_csv_cmd(account)
      cmd =""
      cmd << self.aq_cli
      cmd << " listtrans -c result.ctx -o result.csv --exporter=csv -b #{account.bank_code} -a #{account.account_id}"
    end



    def self.add_account(account)

      system(self.add_account_cmd(account))
      account.build_pin_file
      res = system(self.get_sysid_cmd(account))
      account.delete_pin_file
      res
    end

    def self.delete_account(account)
      unless account.is_a?(Account)
        account = AqBanking::Account.new(account)
      end

      system(self.delete_account_cmd(account.account_id,account.bank_code))
      system(self.delete_user_cmd(account.user_id))

    end

    def self.list_accounts
      res = `#{self.aq_hbci} listaccounts`
    end

    def self.list_users
      res = `#{self.aq_hbci} listusers`

    end

    def self.add_account_cmd(account)
      cmd=""
      cmd << "#{self.aq_hbci} adduser -t pintan --context=1"
      cmd << " -b #{account.bank_code} -u #{account.user_id}"
      cmd << " -c #{account.customer_id}" if account.customer_id
      cmd << " -N \"#{account.user_name}\"" if account.user_name
      cmd << " --hbciversion=#{account.hbci_version || 220}"
      cmd << " -s #{account.server_url}"
    end

    def self.get_sysid_cmd(account)
      cmd =""
      cmd << "#{self.aq_hbci} -P pin getsysid -u #{account.user_id}"
    end

    def self.delete_user_cmd(user_id)
      cmd=""
      cmd << "#{self.aq_hbci} deluser -u #{user_id}"
    end
    def self.delete_account_cmd(account_id,bank_code)
      cmd=""
      cmd << "#{self.aq_hbci} delaccount -b #{bank_code} -a #{account_id}"
    end
  end
end
