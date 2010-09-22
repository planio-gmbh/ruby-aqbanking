require File.join(File.dirname(__FILE__), 'test_helper')

class RequestTest < Test::Unit::TestCase

  def setup
    account = AqRuby::Account.new(:bank_code=>12345, :account_id=>678910, :pin=>"secret")
    @req = AqRuby::Request.new(account, {:type=>"transactions", :from=>Date.new(2010, 1, 1), :to=>Date.new(2010, 9, 20)})

  end


  def test_command_transaction
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx --fromdate=20100101 --todate=20100920 --transactions",
    @req.command
  end

  def test_command_transaction_without_date
    @req.from = nil
    @req.to = nil
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx --transactions",
                 @req.command
  end

  def test_command_balance
    @req.type="balance"
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx --balance",
                 @req.command
  end

  def test_process_result

  end

end