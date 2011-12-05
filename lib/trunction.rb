require "trunction/version"
require "nokogiri"

module Trunction

  extend self

  def truncate_html(html, max)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    Truncation.new(doc, max).execute
    doc.to_html
  end

  class Truncation

    def initialize(doc, max)
      @doc = doc
      @max = max
      @size = 0
    end

    def execute
      find_the_last_block
      remove_everything_after(@last_block_element)
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
