require 'nokogiri'
require 'date'
require 'base64'

module Plistr
  class Document < Nokogiri::XML::SAX::Document
    VALUES = %w(string real integer date data key)
    BOOLEANS = %w(true false)

    attr_reader :value

    def start_document
      @stack = []
      @text = ""
    end

    def start_element(name, attributes)
      return if name == "plist"

      if VALUES.include?(name)
        @stack.push Value.new(name)
      elsif BOOLEANS.include?(name)
        @stack.push Boolean.new(name)
      elsif name == "array"
        @stack.push Array.new
      elsif name == "dict"
        @stack.push Dict.new
      end
    end

    def characters(string)
      @text.concat string
    end

    def end_element(name)
      return unless value = @stack.pop

      if value.is_a?(Value)
        value.text.concat @text.strip
      end
      @text = ""

      if @stack.last.is_a?(Struct)
        @stack.last.push value
      elsif @stack.empty?
        @value = value.parse
      end
    end
  end

  class Element
  end

  class Value < Element
    attr_reader :name, :text

    def initialize(name)
      @name = name
      @text = ""
    end

    def parse
      case @name
      when "string"
        @text
      when "real"
        @text.to_f
      when "integer"
        @text.to_i
      when "date"
        DateTime.parse(@text)
      when "data"
        Base64.decode64(@text.gsub(/\s/, ''))
      when "key"
        @text
      end
    end
  end

  class Boolean < Element
    def initialize(value)
      @value = value
    end

    def parse
      @value == "true"
    end
  end

  class Struct < Element
  end

  class Array < Struct
    def initialize
      @array = []
    end

    def parse
      @array
    end

    def push(value)
      @array.push value.parse
    end
  end

  class Dict < Struct
    def initialize
      @hash = {}
    end

    def parse
      @hash
    end

    def push(value)
      if !@key
        @key = value.text
      else
        @hash[@key] = value.parse
        @key = nil
      end
    end
  end

  class Reader
    def self.open(filename)
      data = File.open(filename)
      new(data)
    end

    def initialize(data)
      @data = data
    end

    def value
      @value || parse
    end

    def parse
      @document = Document.new
      parser = Nokogiri::XML::SAX::Parser.new(@document)
      parser.parse(@data)
      @value = @document.value
    end
  end
end
