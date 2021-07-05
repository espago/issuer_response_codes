# frozen_string_literal: true

module IssuerResponseCodes
  class TdsCode
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

    def reason
      LOCALE_LIBRARY.dig(path: id, scope: "tds_status_codes.targeted.#{target}", locale: locale, default: :unknown)
    end

    alias humanize reason
    alias description reason

    def fraudulent_code?
      @fraudulent_code ||= LOCALE_LIBRARY.dig(path: id, scope: "tds_status_codes.fraudulent_codes", locale: locale)
    end
  end
end
