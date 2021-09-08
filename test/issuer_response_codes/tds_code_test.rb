require_relative '../test_helper'

module IssuerResponseCodes
  class TdsCodeTest < Minitest::Test
    def test_humanize_return_proper_value
      code = IssuerResponseCodes::TdsCode.new(id: "01")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert !code.fraudulent_code?
      assert_equal "Card authentication failed. Please try again.", code.humanize

      code = IssuerResponseCodes::TdsCode.new(id: "09")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Security failure. Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.humanize

      code = IssuerResponseCodes::TdsCode.new(id: "10")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Stolen card. Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.humanize

      code = IssuerResponseCodes::TdsCode.new(id: "11")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Suspected fraud. Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.humanize

      code = IssuerResponseCodes::TdsCode.new(id: "11", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Card authentication failed. Please use a different card or contact issuer.', code.humanize
    end

    def test_humanize_return_unknown_notice
      code = IssuerResponseCodes::TdsCode.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Unknown reason. Please contact our support team.', code.humanize
    end

    def test_description_return_proper_value
      code = IssuerResponseCodes::TdsCode.new(id: "01")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal "Card authentication failed. Please try again.", code.description

      code = IssuerResponseCodes::TdsCode.new(id: "09")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Security failure. Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.description

      code = IssuerResponseCodes::TdsCode.new(id: "10")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Stolen card. Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.description

      code = IssuerResponseCodes::TdsCode.new(id: "11")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Suspected fraud. Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.description

      code = IssuerResponseCodes::TdsCode.new(id: "11", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Card authentication failed. Please use a different card or contact issuer.', code.description
    end

    def test_description_return_unknown_notice
      code = IssuerResponseCodes::TdsCode.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Unknown reason. Please contact our support team.', code.description
    end

    def test_behaviour_return_proper_value
      code = IssuerResponseCodes::TdsCode.new(id: "01")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert !code.fraudulent_code?
      assert_equal "Please try again.", code.behaviour

      code = IssuerResponseCodes::TdsCode.new(id: "09")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.behaviour

      code = IssuerResponseCodes::TdsCode.new(id: "10")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.behaviour

      code = IssuerResponseCodes::TdsCode.new(id: "11", fraud_notice: false)
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Please use a different card or contact issuer.', code.behaviour

      code = IssuerResponseCodes::TdsCode.new(id: "11", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Please use a different card or contact issuer.', code.behaviour

      code = IssuerResponseCodes::TdsCode.new(id: "11")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please use a different card or contact issuer. Transactions with this code may be considered fraudulent.', code.behaviour
    end

    def test_behaviour_return_unknown_notice
      code = IssuerResponseCodes::TdsCode.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please contact our support team.', code.behaviour
    end

    def test_reason_return_proper_value
      code = IssuerResponseCodes::TdsCode.new(id: "01")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal "Card authentication failed.", code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "09")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Security failure.', code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "10")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Stolen card.', code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "11")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Suspected fraud.', code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "11", locale: :pl)
      assert_equal :merchant, code.target
      assert_equal :pl, code.locale
      assert code.fraud_notice
      assert_equal 'Suspected fraud.', code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "11", locale: :pl, target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :pl, code.locale
      assert !code.fraud_notice
      assert_equal 'Negatywny wynik silnego uwierzytelnienia w systemie banku.', code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "11", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Card authentication failed.', code.reason

      code = IssuerResponseCodes::TdsCode.new(id: "11", target: :cardholder, locale: :pl)
      assert_equal :cardholder, code.target
      assert_equal :pl, code.locale
      assert !code.fraud_notice
      assert_equal 'Negatywny wynik silnego uwierzytelnienia w systemie banku.', code.reason
    end

    def test_no_such_target
      assert_raises IssuerResponseCodes::IllegalTarget do
        IssuerResponseCodes::TdsCode.new(id: "11", target: :dupa)
      end
    end

    def test_no_such_locale
      code = IssuerResponseCodes::TdsCode.new(id: "11", locale: :dupa)
      assert_equal :en, code.locale
      assert_equal 'Suspected fraud.', code.reason
    end

    def test_reason_return_unknown_notice
      code = IssuerResponseCodes::TdsCode.new(id: "XX")
      assert_equal 'Unknown reason.', code.reason
    end

    def test_id_empty_string
      code = IssuerResponseCodes::TdsCode.new(id: "")
      assert_equal 'Unknown reason.', code.reason
    end

    def test_id_nil
      code = IssuerResponseCodes::TdsCode.new(id: nil)
      assert_equal 'Unknown reason.', code.reason
    end
  end
end
