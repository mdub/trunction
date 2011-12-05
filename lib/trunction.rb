require "trunction/version"
require "nokogiri"

module Trunction

  extend self

  def truncate_html(html, max)
    Truncation.new(html, max).execute
  end

  class Truncation

    def initialize(html, max)
      @doc = Nokogiri::HTML::DocumentFragment.parse(html)
      @max = max
      @size = 0
    end

    def execute
      find_the_last_block
      return "" if @last_block_element.nil?
      remove_everything_after(@last_block_element)
      @doc.to_html
    end

    private

    def find_the_last_block
      catch(:done) do
        @doc.traverse do |node|
          if node.text?
            accumulate_text(node)
          elsif block?(node)
            @last_block_element = node
          end
        end
      end
    end

    def accumulate_text(text_node)
      @size += text_node.text.length
      throw(:done) if @size >= @max
    end

    def block?(node)
      node.description && node.description.block?
    end

    def remove_everything_after(node)
      while node
        node.next.remove while node.next
        break unless node.respond_to?(:parent)
        node = node.parent
      end
    end

  end

end
