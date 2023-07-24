# frozen_string_literal: true

require 'set'

require_relative 'issuer_response_codes/version'
require_relative 'issuer_response_codes/locale_library'
require_relative 'issuer_response_codes/context'
require_relative 'issuer_response_codes/code'
require_relative 'issuer_response_codes/tds_code'

module IssuerResponseCodes
  class IllegalTarget < StandardError; end
  class IllegalLocale < StandardError; end

  # @return [Set<Symbol>]
  AVAILABLE_TARGETS = ::Set.new(%i[merchant cardholder]).freeze
  # @return [Set<Symbol>]
  AVAILABLE_LOCALES = ::Set.new(%i[en pl da de ee it lt lv sv es fi fr hr nl pt]).freeze

  # @return [LocaleLibrary]
  LOCALE_LIBRARY = LocaleLibrary.new
end
