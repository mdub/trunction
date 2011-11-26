require "trunction/version"
require "nokogiri"

module Trunction

  extend self

  def truncate_html(html, min, max = min)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    chars_remaining = max
    last = 0
    doc.children.each_with_index do |node, i|
      node_length = node.text.length
      break if node_length > chars_remaining
      chars_remaining -= node_length
      last = i
    end
    doc.children[(last + 1)..-1].remove
    doc.to_html
  end

end
