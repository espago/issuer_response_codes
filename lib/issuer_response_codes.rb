# frozen_string_literal: true

require "issuer_response_codes/version"
require "issuer_response_codes/locale_library"
require "issuer_response_codes/context"
require "issuer_response_codes/code"
require "issuer_response_codes/tds_code"

module IssuerResponseCodes
  class IllegalTarget < StandardError; end
  class IllegalLocale < StandardError; end

  AVAILABLE_TARGETS = %i[merchant cardholder].freeze
  AVAILABLE_LOCALES = %i[en pl da de ee it lt lv sv es fi fr hr nl pt].freeze

  LOCALE_LIBRARY = LocaleLibrary.new
end
