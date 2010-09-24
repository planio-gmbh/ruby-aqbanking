require File.join(File.dirname(__FILE__), 'helper')

class TestAccount < Test::Unit::TestCase

  def test_eq
    assert AqBanking::Account.new(:account_id=>12345,:bank_id=>678910) == AqBanking::Account.new(:account_id=>12345,:bank_id=>678910),
    "Accounts are not equal"
  end

  def test_bank_code_business
    assert_equal "11111111", AqBanking::Account.new("business").bank_code
    end
  def test_bank_code_private
    assert_equal "44444444", AqBanking::Account.new("private").bank_code
  end
  def test_bank_code_from_initialize
    assert_equal "1234567", AqBanking::Account.new(:bank_code=>1234567).bank_code
  end
  def test_bank_code_from_new
    a = AqBanking::Account.new
    a.bank_code = "999999"
    assert_equal  "999999", a.bank_code
  end
  def test_build_pin_file
    a = AqBanking::Account.new(:bank_code=>12345,:user_id=>678910,:pin=>"secret")
    a.build_pin_file
    assert File.exists?("pin")
    assert_equal File.new("pin").gets , "PIN_12345_678910 = \"secret\"\n"
  end

  def test_transactions
    a = AqBanking::Account.new(:bank_code=>12345,:user_id=>678910,:pin=>"secret")

    transactions = []
    transactions << AqBanking::Transaction.new(:transaction_id=>"1",:local_bank_code=>"123456",:local_account_number=>"78910",
                                    :remote_bank_code=>"1111111",:remote_account_number=>"22222222",:date=>Date.new(2010,9,10),
                                    :valuta_date=>Date.new(2010,9,10),:amount=>-33.74,:currency=>"EUR",:local_name=>"Duck, Dagobert",
                                    :remote_name=>"Duck, Donald",:purpose=>"Secret Tax\nTransaction\nEntenhausenconnection\n2011")
    transactions.first.instance_variables.each do |var|
        assert_equal transactions.first.instance_variable_get(var),a.transactions.first.instance_variable_get(var),"failed variable #{var}"
    end
  end

  def test_balance
    a = AqBanking::Account.new(:bank_code=>12345,:user_id=>678910,:pin=>"secret")
    assert_equal 2083.38, a.balance
  end

end