require "trunction/version"
require "nokogiri"

module Trunction

  extend self

  def truncate_html(html, min, max = min)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    length = 0
    doc.children.each do |child|
      child_length = child.text.length
      if length + child_length > max
        child.remove
      else
        length += child_length
      end
    end
    doc.to_html
  end

end
