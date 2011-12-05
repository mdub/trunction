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
      @chars_remaining = max
    end

    def execute
      find_the_end
      remove_everything_else
    end

    private

    def find_the_end
      catch(:done) do
        @doc.traverse do |node|
          accumulate_text(node) if node.text?
          record(node)
        end
      end
    end

    def accumulate_text(text_node)
      @chars_remaining -= text_node.text.length
      throw(:done) if limit_reached?
    end

    def limit_reached?
      @chars_remaining <= 0
    end

    def record(node)
      @last_block_element = node if block?(node)
      @last_element = node
    end

    def last_node
      @last_block_element || @last_element
    end

    def block?(node)
      node.description && node.description.block?
    end

    def remove_everything_else
      node = last_node
      while node
        node.next.remove while node.next
        break unless node.respond_to?(:parent)
        node = node.parent
      end
    end

  end

end
