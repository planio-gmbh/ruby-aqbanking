require File.join(File.dirname(__FILE__), 'helper')

class TestRequest < Test::Unit::TestCase

  def setup
    #account = AqRuby::Account.new(:bank_code=>12345, :account_id=>678910, :pin=>"secret")
    #@req = AqRuby::Request.new(account, {:type=>"transactions", :from=>Date.new(2010, 1, 1), :to=>Date.new(2010, 9, 20)})

  end

  def test_eq
    assert AqBanking::Request.new(AqBanking::Account.new,:type=>"transaction") == AqBanking::Request.new(AqBanking::Account.new,:type=>"transaction"),
           "Requests are not equal"
  end


end