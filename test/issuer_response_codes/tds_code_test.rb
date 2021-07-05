require_relative '../test_helper'

module IssuerResponseCodes
  class TdsCodeTest < Minitest::Test
    def test_humanize_return_proper_value
      code = IssuerResponseCodes::TdsCode.new(id: "01")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert !code.fraudulent_code?
      assert_equal "Card authentication failed", code.humanize
      assert_equal "Card authentication failed", code.reason
      assert_equal "Card authentication failed", code.description

      code = IssuerResponseCodes::TdsCode.new(id: "09")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Security failure', code.humanize
      
      code = IssuerResponseCodes::TdsCode.new(id: "09", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Card authentication failed', code.humanize
    end

    def test_humanize_return_unknown_notice
      code = IssuerResponseCodes::TdsCode.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Unknown reason.', code.humanize
    end

    def test_no_such_target
      assert_raises IssuerResponseCodes::IllegalTarget do
        IssuerResponseCodes::Code.new(id: "43", target: :dupa)
      end
    end

    def test_no_such_locale
      assert_raises IssuerResponseCodes::IllegalLocale do
        IssuerResponseCodes::Code.new(id: "43", locale: :dupa)
      end
    end

    def test_reason_return_unknown_notice
      code = IssuerResponseCodes::Code.new(id: "XX")
      assert_equal 'Unknown reason.', code.reason
    end

    def test_id_empty_string
      code = IssuerResponseCodes::Code.new(id: "")
      assert_equal 'Unknown reason.', code.reason
    end

    def test_id_nil
      code = IssuerResponseCodes::Code.new(id: nil)
      assert_equal 'Unknown reason.', code.reason
    end
  end
end
