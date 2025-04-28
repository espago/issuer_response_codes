# frozen_string_literal: true

module IssuerResponseCodes
  # 3D Secure reject reason code.
  class TdsCode < Code
    # @return [String]
    def humanize
      "#{reason} #{behaviour}"
    end

    alias description humanize

    # @return [String]
    def reason
      LOCALE_LIBRARY[
        path:    id,
        scope:   "tds_status_codes.targeted.#{target}",
        locale:  locale,
        default: :unknown
      ]
    end

    # @return [String]
    def behaviour
      behaviour_str = LOCALE_LIBRARY[
        path:    id,
        scope:   'tds_status_codes.behaviour',
        locale:  locale,
        default: :unknown
      ]

      return behaviour_str unless fraud_notice && fraudulent_code?

      "#{behaviour_str} #{LOCALE_LIBRARY[path: 'tds_status_codes.fraud_notice']}"
    end

    # @return [Boolean]
    def fraudulent_code?
      @fraudulent_code ||= LOCALE_LIBRARY[path: id, scope: 'tds_status_codes.fraudulent_codes', locale: locale]
    end

  end
end
