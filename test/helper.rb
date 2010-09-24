require 'yaml'
require 'test/unit'
module AqBanking
  class Commander
  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'environment.yaml'))
end end
module AqBanking
  class Account
  ACCOUNTS = YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'accounts.yaml'))
end end

require File.expand_path(File.dirname(__FILE__) + "/../lib/aq_banking")

module AqBanking
  class Commander
    def self.request_transactions(account,from=nil,to=nil)
      File.new('result.ctx',"w").close
    end
    def self.process_csv(account)
      csv = File.new("result.csv","w")
      csv << '"transactionId";"localBankCode";"localAccountNumber";"remoteBankCode";"remoteAccountNumber";"date";"valutadate";'
      csv << '"value_value";"value_currency";"localName";"remoteName";"remoteName1";"purpose";"purpose1";"purpose2";'
      csv << '"purpose3";"purpose4";"purpose5";"purpose6";"purpose7";"purpose8";"purpose9";"purpose10";"purpose11";"category";'
      csv << '"category1";"category2";"category3";"category4";"category5";"category6";"category7"'
      csv << "\n"
      csv << '"1";"123456";"78910";"1111111";"22222222";"2010/09/10";"2010/09/10";'
      csv << '"-33.74";"EUR";"Duck, Dagobert";"Duck, Donald";"";"Secret Tax";"Transaction";"Entenhausenconnection";"2011"'
      csv << "\n"
      csv.close
    end
    def self.request_balance(account)
      File.new("result.ctx","w").close
    end

    def self.list_balance(account)
      csv = File.new("result.csv","w")
      csv <<  "Account\t123456\t78910\tEntenhausenHouseBank\t\t21.09.2010\t00:00\t2083.38\tEUR\t22.09.2010\t12:20\t0.00\tEUR\t\n"
      csv.close
    end

  end
end
