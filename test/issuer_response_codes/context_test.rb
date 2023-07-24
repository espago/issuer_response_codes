# frozen_string_literal: true

require_relative '../test_helper'

module IssuerResponseCodes
  class ContextTest < Minitest::Test
    def test_create_context_merchant # rubocop:disable Metrics/MethodLength
      context = IssuerResponseCodes::Context.new
      assert_equal :merchant, context.default_target
      assert_equal :en, context.default_locale
      assert context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :merchant)
      assert_equal :merchant, context.default_target
      assert_equal :en, context.default_locale
      assert context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :merchant, fraud_notice_by_default: false)
      assert_equal :merchant, context.default_target
      assert_equal :en, context.default_locale
      assert !context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_locale: :pl)
      assert_equal :merchant, context.default_target
      assert_equal :pl, context.default_locale
      assert context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :merchant, default_locale: :pl)
      assert_equal :merchant, context.default_target
      assert_equal :pl, context.default_locale
      assert context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :merchant,
                                                 fraud_notice_by_default: false,
                                                 default_locale: :pl)
      assert_equal :merchant, context.default_target
      assert_equal :pl, context.default_locale
      assert !context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)
    end

    def test_create_context_cardholder
      context = IssuerResponseCodes::Context.new(default_target: :cardholder)
      assert_equal :cardholder, context.default_target
      assert_equal :en, context.default_locale
      assert !context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :cardholder, fraud_notice_by_default: true)
      assert_equal :cardholder, context.default_target
      assert_equal :en, context.default_locale
      assert context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :cardholder, default_locale: :pl)
      assert_equal :cardholder, context.default_target
      assert_equal :pl, context.default_locale
      assert !context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)

      context = IssuerResponseCodes::Context.new(default_target: :cardholder,
                                                 fraud_notice_by_default: true,
                                                 default_locale: :pl)
      assert_equal :cardholder, context.default_target
      assert_equal :pl, context.default_locale
      assert context.fraud_notice_by_default
      check_if_context_generates_correct_codes(context)
    end

    def test_no_such_target
      assert_raises IssuerResponseCodes::IllegalTarget do
        IssuerResponseCodes::Context.new(default_target: :dupa)
      end
    end

    def test_no_such_locale
      assert_raises IssuerResponseCodes::IllegalLocale do
        IssuerResponseCodes::Context.new(default_locale: :dupa)
      end
    end

    private

    def check_if_context_generates_correct_codes(context) # rubocop:disable Metrics/MethodLength
      code = context.code(id: '00')
      assert code.is_a? IssuerResponseCodes::Code
      assert_equal context.default_target, code.target
      assert_equal context.default_locale, code.locale
      assert_equal context.fraud_notice_by_default, code.fraud_notice

      code = context.code(id: '00', target: :cardholder)
      assert code.is_a? IssuerResponseCodes::Code
      assert_equal :cardholder, code.target
      assert_equal context.default_locale, code.locale
      assert_equal context.fraud_notice_by_default, code.fraud_notice

      code = context.code(id: '00', locale: :lv)
      assert code.is_a? IssuerResponseCodes::Code
      assert_equal context.default_target, code.target
      assert_equal :lv, code.locale
      assert_equal context.fraud_notice_by_default, code.fraud_notice

      code = context.code(id: '00', fraud_notice: false)
      assert code.is_a? IssuerResponseCodes::Code
      assert_equal context.default_target, code.target
      assert_equal context.default_locale, code.locale
      assert_equal false, code.fraud_notice

      # tds codes

      code = context.tds_code(id: '00')
      assert code.is_a? IssuerResponseCodes::TdsCode
      assert_equal context.default_target, code.target
      assert_equal context.default_locale, code.locale
      assert_equal context.fraud_notice_by_default, code.fraud_notice

      code = context.tds_code(id: '00', target: :cardholder)
      assert code.is_a? IssuerResponseCodes::TdsCode
      assert_equal :cardholder, code.target
      assert_equal context.default_locale, code.locale
      assert_equal context.fraud_notice_by_default, code.fraud_notice

      code = context.tds_code(id: '00', locale: :lv)
      assert code.is_a? IssuerResponseCodes::TdsCode
      assert_equal context.default_target, code.target
      assert_equal :lv, code.locale
      assert_equal context.fraud_notice_by_default, code.fraud_notice

      code = context.tds_code(id: '00', fraud_notice: false)
      assert code.is_a? IssuerResponseCodes::TdsCode
      assert_equal context.default_target, code.target
      assert_equal context.default_locale, code.locale
      assert_equal false, code.fraud_notice
    end
  end
end
