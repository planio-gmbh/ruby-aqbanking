require 'yaml'
require File.join(File.dirname(__FILE__), 'aq_banking', 'request')
require File.join(File.dirname(__FILE__), 'aq_banking', 'account')
require File.join(File.dirname(__FILE__), 'aq_banking', 'transaction')
require File.join(File.dirname(__FILE__), 'aq_banking', 'commander')

module AqBanking
  def self.add_account(account)
    if account.is_a?(String)
        account = Account.new(account)
    end
    unless account.is_a?(Account)
      throw "must be account"
    end
    Commander.add_account(account)
  end

end

