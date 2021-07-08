# frozen_string_literal: true

module IssuerResponseCodes
  class TdsCode < Code
    def humanize
      "#{reason} #{behaviour}"
    end

    alias description humanize

    def reason
      LOCALE_LIBRARY.dig(path: id, scope: "tds_status_codes.targeted.#{target}", locale: locale, default: :unknown)
    end

    def behaviour
      behaviour_str = LOCALE_LIBRARY.dig(path: id, scope: "tds_status_codes.behaviour", locale: locale, default: :unknown)
      return behaviour_str unless fraud_notice && fraudulent_code?

      "#{behaviour_str} #{LOCALE_LIBRARY.dig(path: 'tds_status_codes.fraud_notice')}"
    end

    def fraudulent_code?
      @fraudulent_code ||= LOCALE_LIBRARY.dig(path: id, scope: "tds_status_codes.fraudulent_codes", locale: locale)
    end
  end
end
