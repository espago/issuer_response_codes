# frozen_string_literal: true

require_relative '../test_helper'

module IssuerResponseCodes
  class LocaleLibraryTest < Minitest::Test
    def setup
      @library = ::IssuerResponseCodes::LocaleLibrary.new
    end

    def test_that_locales_are_loaded
      ::IssuerResponseCodes::AVAILABLE_LOCALES.each do |name|
        assert @library.locale_hash[name].is_a? Hash
      end
    end

    def test_dig_method
      @library.locale_hash[:en][:issuer_response_codes][:behaviour][:'04'] =
        'Please contact your card issuer and try again later.'

      assert_equal 'Pick up card (no fraud).', @library[path: 'issuer_response_codes.targeted.merchant.04']
      assert_equal 'Pick up card (no fraud).',
                   @library[path: '04', scope: 'issuer_response_codes.targeted.merchant']

      assert_equal 'Please contact your card issuer and try again later.',
                   @library[path: '04', scope: 'issuer_response_codes.behaviour']

      assert_equal 'Pick up card (no fraud).',
                   @library[path: 'issuer_response_codes.targeted.merchant.04', locale: :en]
      assert_equal 'Pick up card (no fraud).',
                   @library[path: '04', scope: 'issuer_response_codes.targeted.merchant', locale: :en]

      assert_equal 'Karta zastrzeżona (z powodów innych niż kradzież/zgubienie).',
                   @library[path: 'issuer_response_codes.targeted.merchant.04', locale: :pl]
      assert_equal 'Karta zastrzeżona (z powodów innych niż kradzież/zgubienie).',
                   @library[path: '04', scope: 'issuer_response_codes.targeted.merchant', locale: :pl]

      assert_nil @library[path: 'issuer_response_codes.targeted.merchant.100']
      assert_nil @library[path: '100', scope: 'issuer_response_codes.targeted.merchant']

      assert_equal 'dupa', @library[path: 'issuer_response_codes.targeted.merchant.100', default: 'dupa']
      assert_equal 'dupa', @library[path: '100', scope: 'issuer_response_codes.targeted.merchant', default: 'dupa']

      assert_equal 'unknown', @library[path: 'issuer_response_codes.targeted.merchant.100', default: :unknown]
      assert_equal 'Unknown reason.',
                   @library[path: '100', scope: 'issuer_response_codes.targeted.merchant', default: :unknown]
      assert_nil @library[path: '100', scope: 'issuer_response_codes.targeted.merchant', default: :doesnt_exist]

      assert_equal 'Unknown reason.',
                   @library[path: '', scope: 'issuer_response_codes.targeted.merchant', default: :unknown]
      assert_equal 'Unknown reason.',
                   @library[path: nil, scope: 'issuer_response_codes.targeted.merchant', default: :unknown]
    end

    def test_issuer_response_codes_method
      @library.locale_hash[:en][:issuer_response_codes] =
        { behaviour: {}, targeted: { merchant: {}, cardholder: {} }, fraudulent_codes: {} }
      @library.locale_hash[:en][:issuer_response_codes][:fraudulent_codes][:'04'] = true
      @library.locale_hash[:en][:issuer_response_codes][:behaviour][:'04'] =
        'Please contact your card issuer and try again later.'
      @library.locale_hash[:en][:issuer_response_codes][:targeted][:merchant][:'04'] = 'Pick up card.'
      @library.locale_hash[:en][:issuer_response_codes][:targeted][:cardholder][:'04'] = 'Card authentication failed.'

      @library.locale_hash[:en][:issuer_response_codes][:behaviour][:'03'] =
        'Please contact your card issuer and try again later.'
      @library.locale_hash[:en][:issuer_response_codes][:targeted][:merchant][:'03'] = 'Card authentication failed.'
      @library.locale_hash[:en][:issuer_response_codes][:targeted][:cardholder][:'03'] = 'Card authentication failed.'

      model_issuer_response_codes = {
        '04': {
          behaviour:         'Please contact your card issuer and try again later.',
          merchant_reason:   'Pick up card.',
          cardholder_reason: 'Card authentication failed.',
          fraudulent:        true,
        },
        '03': {
          behaviour:         'Please contact your card issuer and try again later.',
          merchant_reason:   'Card authentication failed.',
          cardholder_reason: 'Card authentication failed.',
          fraudulent:        false,
        },
      }

      assert_equal model_issuer_response_codes, @library.issuer_response_codes
      assert_equal model_issuer_response_codes, @library.issuer_response_codes(locale: :en)
      assert model_issuer_response_codes != @library.issuer_response_codes(locale: :pl)
    end

    def test_tds_codes_method
      @library.locale_hash[:en][:tds_status_codes] =
        { behaviour: {}, targeted: { merchant: {}, cardholder: {} }, fraudulent_codes: {} }
      @library.locale_hash[:en][:tds_status_codes][:fraudulent_codes][:'04'] = true
      @library.locale_hash[:en][:tds_status_codes][:behaviour][:'04'] =
        'Please contact your card issuer and try again later.'
      @library.locale_hash[:en][:tds_status_codes][:targeted][:merchant][:'04'] = 'Pick up card.'
      @library.locale_hash[:en][:tds_status_codes][:targeted][:cardholder][:'04'] = 'Card authentication failed.'

      @library.locale_hash[:en][:tds_status_codes][:behaviour][:'03'] =
        'Please contact your card issuer and try again later.'
      @library.locale_hash[:en][:tds_status_codes][:targeted][:merchant][:'03'] = 'Card authentication failed.'
      @library.locale_hash[:en][:tds_status_codes][:targeted][:cardholder][:'03'] = 'Card authentication failed.'

      model_tds_codes = {
        '04': {
          behaviour:         'Please contact your card issuer and try again later.',
          merchant_reason:   'Pick up card.',
          cardholder_reason: 'Card authentication failed.',
          fraudulent:        true,
        },
        '03': {
          behaviour:         'Please contact your card issuer and try again later.',
          merchant_reason:   'Card authentication failed.',
          cardholder_reason: 'Card authentication failed.',
          fraudulent:        false,
        },
      }

      assert_equal model_tds_codes, @library.tds_codes
      assert_equal model_tds_codes, @library.tds_codes(locale: :en)
      assert model_tds_codes != @library.tds_codes(locale: :pl)
    end
  end
end
