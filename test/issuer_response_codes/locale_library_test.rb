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
      assert_equal 'Pickup card.', @library.dig(path: 'issuer_response_codes.targeted.merchant.04')
      assert_equal 'Pickup card.', @library.dig(path: '04', scope: 'issuer_response_codes.targeted.merchant')

      assert_equal 'Please contact your card issuer and try again later. ', @library.dig(path: '04', scope: 'issuer_response_codes.behaviour')
      assert_equal 'Please contact your card issuer and try again later. dupa', @library.dig(path: '04', scope: 'issuer_response_codes.behaviour', substitute: 'dupa')

      assert_equal 'Pickup card.', @library.dig(path: 'issuer_response_codes.targeted.merchant.04', locale: :en)
      assert_equal 'Pickup card.', @library.dig(path: '04', scope: 'issuer_response_codes.targeted.merchant', locale: :en)

      assert_equal 'Karta zastrzeżona.', @library.dig(path: 'issuer_response_codes.targeted.merchant.04', locale: :pl)
      assert_equal 'Karta zastrzeżona.', @library.dig(path: '04', scope: 'issuer_response_codes.targeted.merchant', locale: :pl)

      assert_nil @library.dig(path: 'issuer_response_codes.targeted.merchant.100')
      assert_nil @library.dig(path: '100', scope: 'issuer_response_codes.targeted.merchant')

      assert_equal 'dupa', @library.dig(path: 'issuer_response_codes.targeted.merchant.100', default: 'dupa')
      assert_equal 'dupa', @library.dig(path: '100', scope: 'issuer_response_codes.targeted.merchant', default: 'dupa')

      assert_equal 'unknown', @library.dig(path: 'issuer_response_codes.targeted.merchant.100', default: :unknown)
      assert_equal 'Unknown reason.', @library.dig(path: '100', scope: 'issuer_response_codes.targeted.merchant', default: :unknown)
      assert_nil @library.dig(path: '100', scope: 'issuer_response_codes.targeted.merchant', default: :doesnt_exist)

      assert_equal 'Unknown reason.', @library.dig(path: '', scope: 'issuer_response_codes.targeted.merchant', default: :unknown)
      assert_equal 'Unknown reason.', @library.dig(path: nil, scope: 'issuer_response_codes.targeted.merchant', default: :unknown)
    end
  end
end
