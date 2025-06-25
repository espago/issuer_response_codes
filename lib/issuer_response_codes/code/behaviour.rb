# typed: true
# frozen_string_literal: true

require_relative 'behaviour/dsl'

module IssuerResponseCodes
  class Code
    # Defines behaviour codes for issuer response codes
    class Behaviour
      class << self
        #: (String) -> Symbol
        def [](code)
          @map.fetch(code, :retry)
        end

      end

      abort_behaviour %w[46 R0 R1 R3 B1A B04 B14 B15 B41 B43 B54 B65]
      retry_later_behaviour %w[22 24 25 26 81 84 00 E3 E4 E5 Q2 91]
      sca_required_behaviour %w[1A 65 O5]
      invalid_card_behaviour %w[04 07 12 14 15 41 43 57]
      invalid_amount_behaviour %w[61 13]
    end
  end
end
