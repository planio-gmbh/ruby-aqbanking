require(File.join(File.dirname(__FILE__), 'lib', 'aq_ruby'))

task :create_accounts do
  ACCOUNTS.each do |k,v|
    AqRuby.add_account(k)
  end
end

