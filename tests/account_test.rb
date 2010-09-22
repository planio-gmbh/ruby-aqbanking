require File.join(File.dirname(__FILE__), 'test_helper')

class AccountTest < Test::Unit::TestCase

  def test_bank_code_business
    assert_equal "11111111", AqRuby::Account.new("business").bank_code
    end
  def test_bank_code_private
    assert_equal "44444444", AqRuby::Account.new("private").bank_code
  end
  def test_bank_code_from_initialize
    assert_equal "1234567", AqRuby::Account.new(:bank_code=>1234567).bank_code
  end
  def test_bank_code_from_new
    a = AqRuby::Account.new
    a.bank_code = "999999"
    assert_equal  "999999", a.bank_code
  end
  def test_build_pin_file
    a = AqRuby::Account.new(:bank_code=>12345,:user_id=>678910,:pin=>"secret")
    a.build_pin_file
    assert File.exists?("pin")
    assert_equal File.new("pin").gets , "PIN_12345_678910 = \"secret\""
  end

end