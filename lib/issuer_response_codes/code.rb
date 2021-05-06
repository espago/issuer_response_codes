# frozen_string_literal: true

module IssuerResponseCodes
  class Code
    attr_reader :id, :target, :locale, :fraud_notice

    NOT_PROVIDED = ::Object.new

    def initialize(id:, target: :merchant, locale: :en, fraud_notice: NOT_PROVIDED)
      @id = id
      @target = target
      @locale = locale

      raise IllegalLocale, "No such locale: #{locale.inspect}" unless AVAILABLE_LOCALES.include?(locale)
      raise IllegalTarget, "No such target: #{target.inspect}" unless AVAILABLE_TARGETS.include?(target)

      if fraud_notice != NOT_PROVIDED
        @fraud_notice = fraud_notice
        return
      end

      @fraud_notice = target == :merchant
    end

    def humanize
      "#{reason} #{behaviour}"
    end

    alias description humanize

    def reason
      LOCALE_LIBRARY.dig(path: id, scope: "issuer_response_codes.targeted.#{target}", locale: locale, default: :unknown)
    end

    def behaviour
      fraud_notice_str = fraud_notice ? LOCALE_LIBRARY.dig(path: 'issuer_response_codes.fraud_notice') : ''
      LOCALE_LIBRARY.dig(path: id, substitute: fraud_notice_str, scope: "issuer_response_codes.behaviour", locale: locale, default: :unknown)
    end
  end
end
