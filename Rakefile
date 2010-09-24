require(File.join(File.dirname(__FILE__), 'lib', 'aq_banking'))

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

namespace :aqbanking do
  desc "Prepares the local system for aqbanking"
  task :create_accounts do
    AqBanking::Account::ACCOUNTS.each do |k, v|
      AqBanking.add_account(k)
    end
  end

  desc "Cleans all users and account from the local system "
  task :cleanup do
    users_str = AqBanking::Commander.list_users
    accounts_str = AqBanking::Commander.list_accounts
    accounts_str.each_line do |line|
      a = line[/Account Number: ([^ .]*)/, 1]
      b = line[/Bank: ([^ .]*)/, 1]
      system(AqBanking::Commander.delete_account_cmd(a, b))
    end
    users_str.each_line do |line|
      user_id = line[/User Id: ([^ .]*)/, 1]
      system(AqBanking::Commander.delete_user_cmd(user_id))
    end
  end


end