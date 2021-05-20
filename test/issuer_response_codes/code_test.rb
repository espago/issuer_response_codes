require_relative '../test_helper'

module IssuerResponseCodes
  class CodeTest < Minitest::Test
    def test_humanize_return_proper_value
      code = IssuerResponseCodes::Code.new(id: "00")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal "Transaction rejected due to no response from issuer/bank, inactive Merchant account, used not supported card or incorrect card data. Check the card's data or please try again later.", code.humanize
      
      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'No privileges to execute this transaction for your card. Please contact your card issuer to get more details and try again later.', code.humanize
      
      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Expired card. Please check your card or try another.', code.humanize

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Stolen card. Please contact your card issuer to get more details and try again later. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.humanize
      
      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Your bank has declined this transaction. Please contact your card issuer to get more details and try again later. ', code.humanize
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
      assert_equal "Transaction rejected due to no response from issuer/bank, inactive Merchant account, used not supported card or incorrect card data. Check the card's data or please try again later.", code.description
      
      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'No privileges to execute this transaction for your card. Please contact your card issuer to get more details and try again later.', code.description
      
      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Expired card. Please check your card or try another.', code.description

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Stolen card. Please contact your card issuer to get more details and try again later. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.description
      
      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Your bank has declined this transaction. Please contact your card issuer to get more details and try again later. ', code.description
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
      assert_equal "Check the card's data or please try again later.", code.behaviour

      code = IssuerResponseCodes::Code.new(id: "12")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please contact your card issuer to get more details and try again later.', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please check your card or try another.', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "43", fraud_notice: false)
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Please contact your card issuer to get more details and try again later. ', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Please contact your card issuer to get more details and try again later. ', code.behaviour

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Please contact your card issuer to get more details and try again later. IMPORTANT NOTICE: It is forbidden to retry transactions that ended with this code. It may be recognized as a fraud attempt!', code.behaviour
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
      assert_equal 'No privileges to execute this transaction for your card.', code.reason

      code = IssuerResponseCodes::Code.new(id: "54")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Expired card.', code.reason

      code = IssuerResponseCodes::Code.new(id: "43")
      assert_equal :merchant, code.target
      assert_equal :en, code.locale
      assert code.fraud_notice
      assert_equal 'Stolen card.', code.reason

      code = IssuerResponseCodes::Code.new(id: "43", locale: :pl)
      assert_equal :merchant, code.target
      assert_equal :pl, code.locale
      assert code.fraud_notice
      assert_equal 'Karta oznaczona jako skradziona.', code.reason

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder)
      assert_equal :cardholder, code.target
      assert_equal :en, code.locale
      assert !code.fraud_notice
      assert_equal 'Your bank has declined this transaction.', code.reason

      code = IssuerResponseCodes::Code.new(id: "43", target: :cardholder, locale: :pl)
      assert_equal :cardholder, code.target
      assert_equal :pl, code.locale
      assert !code.fraud_notice
      assert_equal 'Bank odrzucił autoryzację.', code.reason
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
