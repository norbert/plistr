require 'nokogiri'
require 'time'
require 'base64'

class Plistr
  class Value
    def initialize(element)
      @element = element
    end

    def parse
      case @element.name
      when "string"
        @element.text
      when "real"
        @element.text.to_f
      when "integer"
        @element.text.to_i
      when "true"
        true
      when "false"
        false
      when "date"
        Time.iso8601(@element.text)
      when "data"
        Base64.decode64(@element.text.gsub(/\s/, ''))
      when "array"
        parse_array
      when "dict"
        parse_dict
      end
    end

    private
      def parse_array
        values = @element.xpath('*').map { |element| Value.new(element) }
        values.map { |value| value.parse }
      end

      def parse_dict
        elements = @element.xpath('*')

        dict = {}
        key = nil
        elements.each do |element|
          if key.nil?
            key = element.text
          else
            dict[key] = Value.new(element).parse
            key = nil
          end
        end

        dict
      end
  end

  class << self
    def read(filename)
      data = File.read(filename)
      new(data)
    end
  end

  def initialize(data)
    @document = Nokogiri::XML.parse(data)
    root = @document.xpath('/plist/*').first
    @value = Value.new(root)
  end

  def parse
    @value.parse
  end
end
