require "trunction/version"
require "nokogiri"

module Trunction

  extend self

  def truncate_html(html, min, max = min)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    remove_everything_after(last_allowable_element_in(doc, max))
    doc.to_html
  end

  private

  def last_allowable_element_in(doc, max)
    last_element = doc
    chars_remaining = max
    doc.traverse do |node|
      if node.text?
        chars_remaining -= node.text.length
        break unless chars_remaining > 0
      end
      last_element = node
    end
    last_element
  end

  def remove_everything_after(node)
    while node
      node.next.remove while node.next
      break unless node.respond_to?(:parent)
      node = node.parent
    end
  end

end
