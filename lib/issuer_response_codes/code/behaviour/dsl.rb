# typed: true
# frozen_string_literal: true

module IssuerResponseCodes
  class Code
    class Behaviour # rubocop:disable Style/StaticClass,Style/Documentation
      @map = {} #: Hash[String, Symbol]

      class << self
        #: (Array[String]) -> void
        def abort_behaviour(codes)
          behaviour(:abort, codes)
        end

        #: (Array[String]) -> void
        def retry_later_behaviour(codes)
          behaviour(:retry_later, codes)
        end

        #: (Array[String]) -> void
        def sca_required_behaviour(codes)
          behaviour(:sca_required, codes)
        end

        #: (Array[String]) -> void
        def invalid_card_behaviour(codes)
          behaviour(:invalid_card, codes)
        end

        #: (Array[String]) -> void
        def invalid_amount_behaviour(codes)
          behaviour(:invalid_amount, codes)
        end

        #: (Symbol, Array[String]) -> void
        def behaviour(type, codes)
          codes.each do |code|
            @map[code] = type
          end
        end

      end
    end
  end
end
