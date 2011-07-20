require 'where_utils'

module WhereUtilsHelper
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
  end

  module InstanceMethods
    # Generate kana links
    #
    # == Configration options
    #
    # *<tt>url_string</tt> - url to link
    # *<tt>options</tt> -
    #   * separator - separator for each links (defalut: ' | ')
    #
    # Examples:
    #
    #  <%= kana_links books_path, :separator => ', '
    #
    def kana_links(url_string, options = {})
      options[:separator] ||= ' | '
      url = URI.parse(url_string)
      url_params = Rack::Utils.parse_nested_query(url.query).symbolize_keys
      url_params = url_params.merge(options[:url_params].symbolize_keys) unless options[:url_params].blank?
      url_params.delete(:kana)
      if params.is_a? Hash
        links = WhereUtils::KANA_KEYS.map { |kana|
          params = url_params.merge(:kana => kana[:key])
          url.query = params.to_query
          link_to kana[:name], url.to_s
        }
      end

      raw links.join(options[:separator])
    end
  end
end
