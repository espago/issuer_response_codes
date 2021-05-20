# frozen_string_literal: true

require 'yaml'
require 'byebug'

module IssuerResponseCodes
  class LocaleLibrary
    attr_reader :locale_hash

    def initialize
      @locale_hash = {}

      AVAILABLE_LOCALES.each do |locale|
        load_locale(locale)
      end
    end

    def dig(path:, locale: :en, scope: '', default: nil, substitute: '')
      result = __dig__(path: path, locale: locale, scope: scope, default: default)
      return result unless result

      result.gsub(/%{substitute}/, substitute)
    end

    def self.symbolize_keys(hash)
      h = hash.map do |k, v|
        v_sym = if v.instance_of? Hash
                  symbolize_keys(v)
                else
                  v
                end

        [k.to_sym, v_sym]
      end

      h.to_h
    end

    private

    def __dig__(path:, locale: :en, scope: '', default: nil)
      result = dig_provided_path(path, scope, locale)
      return result if result || !default

      return default.to_s if default.is_a?(String) || scope.empty?

      dig_provided_path(default.to_s, scope, locale)
    end

    def dig_provided_path(path, scope, locale)
      return if path.nil? || path.empty?

      full_path_array = [locale]
      full_path_array.append(*scope.split('.').map(&:to_sym))
      full_path_array.append(*path.split('.').map(&:to_sym))

      locale_hash.dig(*full_path_array)
    end

    def load_locale(name)
      name_str = name.to_s

      raw_hash = ::YAML.load_file(::File.join(::File.dirname(::File.expand_path(__FILE__)), "../locale/#{name_str}.yml"))[name_str]
      single_locale_hash = self.class.symbolize_keys(raw_hash)
      @locale_hash[name] = single_locale_hash
    end
  end
end
