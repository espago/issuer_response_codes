# frozen_string_literal: true

module IssuerResponseCodes
  # ISO-8583 Response code.
  class Code
    attr_reader :id, :target, :locale, :fraud_notice

    NOT_PROVIDED = ::Object.new

    # @param id [String]
    # @param target [Symbol]
    # @param locale [Symbol]
    # @param fraud_notice [Boolean, Object]
    def initialize(id:, target: :merchant, locale: :en, fraud_notice: NOT_PROVIDED)
      @id = id
      @target = target
      @locale = locale

      @locale = :en unless AVAILABLE_LOCALES.include?(locale)
      raise IllegalTarget, "No such target: #{target.inspect}" unless AVAILABLE_TARGETS.include?(target)

      if fraud_notice != NOT_PROVIDED
        @fraud_notice = fraud_notice
        return
      end

      @fraud_notice = target == :merchant
    end

    # @return [String]
    def humanize
      "#{reason} #{behaviour}"
    end
    alias description humanize

    # @return [String]
    def reason
      LOCALE_LIBRARY[path: id,
                     scope: "issuer_response_codes.targeted.#{target}",
                     locale: locale,
                     default: :unknown]
    end

    # @return [String]
    def behaviour
      behaviour_str = LOCALE_LIBRARY[path: id,
                                     scope: 'issuer_response_codes.behaviour',
                                     locale: locale,
                                     default: :unknown]
      return behaviour_str unless fraud_notice && fraudulent_code?

      "#{behaviour_str} #{LOCALE_LIBRARY[path: 'issuer_response_codes.fraud_notice']}"
    end

    # @return [Boolean]
    def fraudulent_code?
      @fraudulent_code ||= LOCALE_LIBRARY[path: id, scope: 'issuer_response_codes.fraudulent_codes', locale: locale]
    end

  end
end
