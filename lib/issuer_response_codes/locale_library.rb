# typed: true
# frozen_string_literal: true

require 'yaml'

module IssuerResponseCodes
  # Stores the translations of codes.
  class LocaleLibrary
    attr_reader :locale_hash

    #: -> void
    def initialize
      @locale_hash = {}

      AVAILABLE_LOCALES.each do |locale|
        load_locale(locale)
      end
    end

    #: (path: String | Symbol, ?locale: Symbol, ?scope: String, ?default: Symbol | String?) -> untyped
    def dig(path:, locale: :en, scope: '', default: nil)
      __dig__(path: path, locale: locale, scope: scope, default: default)
    end
    alias [] dig

    #: (?locale: Symbol) -> Hash[Symbol, Hash[Symbol, untyped]]
    def issuer_response_codes(locale: :en)
      behaviours = locale_hash.dig(locale, :issuer_response_codes, :behaviour)
      cardholder_reasons = locale_hash.dig(locale, :issuer_response_codes, :targeted, :cardholder)
      merchant_reasons = locale_hash.dig(locale, :issuer_response_codes, :targeted, :merchant)

      merchant_reasons.to_h do |code, merchant_reason|
        [
          code,
          {
            merchant_reason:   merchant_reason,
            cardholder_reason: cardholder_reasons[code],
            behaviour:         behaviours[code],
            fraudulent:        Code::FRAUDULENT_IDS.include?(code.to_s),
          },
        ]
      end
    end

    #: (?locale: Symbol) -> Hash[Symbol, Hash[Symbol, untyped]]
    def tds_codes(locale: :en)
      behaviours = locale_hash.dig(locale, :tds_status_codes, :behaviour)
      cardholder_reasons = locale_hash.dig(locale, :tds_status_codes, :targeted, :cardholder)
      merchant_reasons = locale_hash.dig(locale, :tds_status_codes, :targeted, :merchant)

      merchant_reasons.to_h do |code, merchant_reason|
        [
          code,
          {
            merchant_reason:   merchant_reason,
            cardholder_reason: cardholder_reasons[code],
            behaviour:         behaviours[code],
            fraudulent:        TdsCode::FRAUDULENT_IDS.include?(code.to_s),
          },
        ]
      end
    end

    private

    #: (path: String | Symbol, ?locale: Symbol, ?scope: String, ?default: Symbol | String?) -> untyped
    def __dig__(path:, locale: :en, scope: '', default: nil)
      result = dig_provided_path(path, scope, locale)
      return result if result || !default

      return default.to_s if default.is_a?(String) || scope.empty?

      dig_provided_path(default.to_s, scope, locale)
    end

    def dig_provided_path(path, scope, locale)
      return if path.nil? || path.empty?

      full_path_array = [locale]
      full_path_array.append(*scope.split('.').map(&:to_sym))
      full_path_array.append(*path.split('.').map(&:to_sym))

      locale_hash.dig(*full_path_array)
    end

    #: (Symbol | String) -> void
    def load_locale(name)
      raw_hash = load_yaml(::File.join(::File.dirname(::File.expand_path(__FILE__)), "../locale/#{name}.yml"))
      name = name.to_sym

      @locale_hash[name] = raw_hash[name]
    end

    if ::Psych::VERSION > T.unsafe('4') # rubocop:disable Sorbet/ForbidTUnsafe,Style/YodaCondition
      #: (String) -> Hash[Symbol, untyped]
      def load_yaml(file_path)
        ::YAML.load_file(
          file_path,
          symbolize_names: true,
          aliases:         true,
        )
      end
    else
      #: (String) -> Hash[Symbol, untyped]
      def load_yaml(file_path)
        ::YAML.load_file(
          file_path,
          symbolize_names: true,
        )
      end
    end

  end
end
