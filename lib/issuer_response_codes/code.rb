# typed: true
# frozen_string_literal: true

require_relative 'code/behaviour'

module IssuerResponseCodes
  # ISO-8583 Response code.
  class Code
    #: String
    attr_reader :id
    #: Symbol
    attr_reader :target
    #: Symbol
    attr_reader :locale
    #: bool
    attr_reader :fraud_notice

    FRAUDULENT_IDS = %w[04 B04 07 12 14 B14 15 B15 41 B41 43 B43 54 B54 57 59 63 R0 R1 R3].to_set #: Set[String]

    NOT_PROVIDED = ::Object.new #: as untyped

    #: (id: String | Symbol, ?target: Symbol, ?locale: Symbol, ?fraud_notice: bool) -> void
    def initialize(id:, target: :merchant, locale: :en, fraud_notice: NOT_PROVIDED)
      @id = id.to_s
      @target = target
      @locale = locale

      @locale = :en unless AVAILABLE_LOCALES.include?(locale)
      raise IllegalTarget, "No such target: #{target.inspect}" unless AVAILABLE_TARGETS.include?(target)

      if fraud_notice != NOT_PROVIDED
        @fraud_notice = fraud_notice
        return
      end

      @fraud_notice = target == :merchant #: bool
    end

    #: -> String
    def humanize
      "#{reason} #{behaviour}"
    end
    alias description humanize

    #: -> String
    def reason
      LOCALE_LIBRARY[
        path:    id,
        scope:   "issuer_response_codes.targeted.#{target}",
        locale:  locale,
        default: :unknown,
      ]
    end

    #: -> String
    def behaviour
      behaviour_str = LOCALE_LIBRARY[
        path:    id,
        scope:   'issuer_response_codes.behaviour',
        locale:  locale,
        default: :unknown,
      ]

      return behaviour_str unless fraud_notice && fraudulent_code?

      "#{behaviour_str} #{LOCALE_LIBRARY[path: 'issuer_response_codes.fraud_notice']}"
    end

    #: -> Symbol
    def behaviour_code
      Behaviour[id]
    end

    #: -> bool
    def fraudulent_code?
      FRAUDULENT_IDS.include?(id)
    end

  end
end
