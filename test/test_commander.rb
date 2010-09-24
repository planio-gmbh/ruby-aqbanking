require File.join(File.dirname(__FILE__), 'helper')

class TestCommander < Test::Unit::TestCase

  def setup
    @account = AqBanking::Account.new(:bank_code=>12345,:account_id=>678910)
  end

  def test_aqhbci
    assert_equal "/path/to/aqbankng/bin/aqhbci-tool4", AqBanking::Commander.aq_hbci
  end

  def test_aq_cli
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli", AqBanking::Commander.aq_cli
  end

  def test_list_balance_cmd
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli listbal -c result.ctx -o result.csv", AqBanking::Commander.list_balance_cmd
  end

  def test_request_balance_cmd

    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx --balance", AqBanking::Commander.request_balance_cmd(@account)
  end

  def test_bascis_request_cmd
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx", AqBanking::Commander.basic_request_cmd(@account)
  end

  def test_request_transaction_cmd
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx --fromdate=20100101 --todate=20100601 --transactions",
    AqBanking::Commander.request_transactions_cmd(@account, Date.new(2010,1,1), Date.new(2010,6,1))
  end

  def test_request_transaction_without_date_cmd
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli -P pin request -b 12345 -a 678910 -c result.ctx --transactions",
    AqBanking::Commander.request_transactions_cmd(@account)
  end

  def test_process_csv_cmd
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli listtrans -c result.ctx -o result.csv --exporter=csv -b 12345 -a 678910", AqBanking::Commander.process_csv_cmd(@account)
  end

  def test_request_transactions_creates_result_ctx
    AqBanking::Commander.request_transactions(@account)
    assert File.exists?("result.ctx")
  end

end