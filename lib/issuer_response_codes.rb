# frozen_string_literal: true

require "issuer_response_codes/version"
require "issuer_response_codes/locale_library"
require "issuer_response_codes/context"
require "issuer_response_codes/code"

module IssuerResponseCodes
  class IllegalTarget < StandardError; end
  class IllegalLocale < StandardError; end

  AVAILABLE_TARGETS = %i[merchant cardholder].freeze
  AVAILABLE_LOCALES = %i[en pl da ee lt lv sv].freeze

  LOCALE_LIBRARY = LocaleLibrary.new
end
