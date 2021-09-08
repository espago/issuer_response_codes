require_relative '../test_helper'

module IssuerResponseCodes
  class CodeTest < Minitest::Test
    def test_humanize_return_proper_value
      code = IssuerResponseCodes::Code.new(id: "00")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert !code.fraudulent_code?
      assert_equal "Transaction rejected due to no response from issuer/bank, inactive Merchant account, used not supported card or incorrect card data. Please try again or contact the seller.", code.humanize

      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Invalid transaction. Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.humanize

      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Expired card or expiration date is missing. Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.humanize

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Stolen card, pick up (fraud account). Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.humanize

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Payment rejected by the issuer. Please use a different card or contact the issuer for clarification.', code.humanize
    end

    def test_humanize_return_unknown_notice
      code = IssuerResponseCodes::Code.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Unknown reason. Please contact our support team.', code.humanize
    end

    def test_description_return_proper_value
      code = IssuerResponseCodes::Code.new(id: "00")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal "Transaction rejected due to no response from issuer/bank, inactive Merchant account, used not supported card or incorrect card data. Please try again or contact the seller.", code.description

      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Invalid transaction. Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.description

      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Expired card or expiration date is missing. Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.description

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Stolen card, pick up (fraud account). Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.description

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Payment rejected by the issuer. Please use a different card or contact the issuer for clarification.', code.description
    end

    def test_description_return_unknown_notice
      code = IssuerResponseCodes::Code.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Unknown reason. Please contact our support team.', code.description
    end

    def test_behaviour_return_proper_value
      code = IssuerResponseCodes::Code.new(id: "00")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert !code.fraudulent_code?
      assert_equal "Please try again or contact the seller.", code.behaviour

      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert code.fraudulent_code?
      assert_equal 'Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "43", fraud_notice: false)
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Please use a different card or contact the issuer for clarification.', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Please use a different card or contact the issuer for clarification.', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please use a different card or contact the issuer for clarification. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.behaviour
    end

    def test_behaviour_return_unknown_notice
      code = IssuerResponseCodes::Code.new(id: "XX")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please contact our support team.', code.behaviour
    end

    def test_reason_return_proper_value
      code = IssuerResponseCodes::Code.new(id: "00")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal "Transaction rejected due to no response from issuer/bank, inactive Merchant account, used not supported card or incorrect card data.", code.reason

      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Invalid transaction.', code.reason

      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Expired card or expiration date is missing.', code.reason

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Stolen card, pick up (fraud account).', code.reason

      code = IssuerResponseCodes::Code.new(id: "43", locale: :pl)
      assert_equal :merchant, code.target
      assert_equal :pl, code.locale
      assert code.fraud_notice
      assert_equal 'Karta oznaczona jako skradziona', code.reason

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Payment rejected by the issuer.', code.reason

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder, locale: :pl)
      assert_equal :cardholder, code.target
      assert_equal :pl, code.locale
      assert !code.fraud_notice
      assert_equal 'Płatność odrzucona przez bank.', code.reason
    end

    def test_no_such_target
      assert_raises IssuerResponseCodes::IllegalTarget do
        IssuerResponseCodes::Code.new(id: "43", target: :dupa)
      end
    end

    def test_no_such_locale
      code = IssuerResponseCodes::Code.new(id: "43", locale: :dupa)
      assert_equal :en, code.locale
      assert_equal 'Stolen card, pick up (fraud account).', code.reason
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
