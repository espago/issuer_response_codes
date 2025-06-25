# typed: true
# frozen_string_literal: true

module IssuerResponseCodes
  # 3D Secure reject reason code.
  class TdsCode < Code
    FRAUDULENT_IDS = %w[09 10 11].to_set #: Set[String]

    #: -> String
    def humanize
      "#{reason} #{behaviour}"
    end

    alias description humanize

    #: -> String
    def reason
      LOCALE_LIBRARY[
        path:    id,
        scope:   "tds_status_codes.targeted.#{target}",
        locale:  locale,
        default: :unknown,
      ]
    end

    #: -> String
    def behaviour
      behaviour_str = LOCALE_LIBRARY[
        path:    id,
        scope:   'tds_status_codes.behaviour',
        locale:  locale,
        default: :unknown,
      ]

      return behaviour_str unless fraud_notice && fraudulent_code?

      "#{behaviour_str} #{LOCALE_LIBRARY[path: 'tds_status_codes.fraud_notice']}"
    end

    #: -> bool
    def fraudulent_code?
      FRAUDULENT_IDS.include?(id)
    end

  end
end
