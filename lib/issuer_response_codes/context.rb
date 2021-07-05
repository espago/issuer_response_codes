# frozen_string_literal: true

module IssuerResponseCodes
  class Context
    attr_reader :default_target, :default_locale, :fraud_notice_by_default

    NOT_PROVIDED = ::Object.new

    def initialize(default_target: :merchant, default_locale: :en, fraud_notice_by_default: NOT_PROVIDED)
      @default_target = default_target
      @default_locale = default_locale

      raise IllegalLocale, "No such locale: #{default_locale.inspect}" unless AVAILABLE_LOCALES.include?(default_locale)
      raise IllegalTarget, "No such target: #{default_target.inspect}" unless AVAILABLE_TARGETS.include?(default_target)

      if fraud_notice_by_default != NOT_PROVIDED
        @fraud_notice_by_default = fraud_notice_by_default
        return
      end

      @fraud_notice_by_default = default_target == :merchant
    end

    def code(id:, target: default_target, locale: default_locale, fraud_notice: fraud_notice_by_default)
      Code.new(id: id, target: target, locale: locale, fraud_notice: fraud_notice)
    end

    def tds_code(id:, target: default_target, locale: default_locale, fraud_notice: fraud_notice_by_default)
      TdsCode.new(id: id, target: target, locale: locale, fraud_notice: fraud_notice)
    end
  end
end
