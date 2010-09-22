require File.join(File.dirname(__FILE__), 'test_helper')

class AqRubyTest < Test::Unit::TestCase
  def test_aqhbci
    assert_equal "/path/to/aqbankng/bin/aqhbci-tool4", AqRuby::aq_hbci
  end

  def test_aq_cli
    assert_equal "/path/to/aqbankng/bin/aqbanking-cli", AqRuby::aq_cli
  end

  def add_user_cmd
    assert_equal "/path/to/aqbankng/bin/aqhbci-tool4 adduser -t pintan --context=1 -b 11111111 -u 22222222 -c 33333333 -N \"Dagobert Duck\" --hbciversion=220 -s https://my.bank.de",
    AqRuby.add_account_cmd(AqRuby::Account.new("business"))
  end

  def test_add_user
    assert_equal true, AqRuby.add_account("manuel")
  end

end