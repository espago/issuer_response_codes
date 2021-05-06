require "test_helper"

class IssuerResponseCodesTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IssuerResponseCodes::VERSION
  end

  def test_that_locales_are_loaded
    ::IssuerResponseCodes::AVAILABLE_LOCALES.each do |name|
      assert ::IssuerResponseCodes::LOCALE_LIBRARY.locale_hash[name].is_a? Hash
    end
  end
end
