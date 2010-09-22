require 'yaml'
CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..','config', 'environment.yaml')) unless defined? CONFIG
ACCOUNTS = YAML.load_file(File.join(File.dirname(__FILE__), '..','config', 'accounts.yaml')) unless defined? ACCOUNTS


module AqRuby
  def self.aq_hbci
    CONFIG["aqhbci_tool"]
  end
  def self.aq_cli
    CONFIG["aqbanking_cli"]
  end
  def self.add_account(account)

    unless account.is_a?(Account)
      account = AqRuby::Account.new(account)
    end

    system(self.add_account_cmd(account))
    account.build_pin_file
    res = system(self.get_sysid_cmd(account))
    account.delete_pin_file
    res

  end

  def self.delete_account(account)
    unless account.is_a?(Account)
      account = AqRuby::Account.new(account)
    end

    # to it twice seems to be bug
    system(self.delete_account_cmd(account))
    system(self.delete_account_cmd(account))

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

  def self.delete_account_cmd(account)
    cmd=""
    cmd << "#{self.aq_hbci} deluser -u #{account.user_id} --with-accounts"

  end
end

require File.join(File.dirname(__FILE__), 'aqruby', 'request')
require File.join(File.dirname(__FILE__), 'aqruby', 'account')
