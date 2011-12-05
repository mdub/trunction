# encoding: utf-8

require 'trunction'

describe Trunction do

  let(:full_text) { Nokogiri::HTML::DocumentFragment.parse(input).text }
  let(:total_words) { full_text.split.length }
  let(:ellipsis) { "&#8230;" }

  include Trunction

  let(:result) do
    truncate_html(input, max_words).gsub("\n", '')
  end

  describe "#truncate_html" do

    context "given multiple paragraphs" do

      let(:input) { "<p>One two three.</p> <p>Four five six.</p>" }

      context "with max-length longer than input" do

        let(:max_words) { total_words + 1 }

        it "returns input intact" do
          result.should == input
        end

      end

      context "with max-length shorter than input" do

        let(:max_words) { total_words - 1 }

        it "drops block elements until beneath max-length" do
          result.should == "<p>One two three.</p>"
        end

      end

      context "with max-length shorter than first paragraph" do

        let(:max_words) { 1 }

        it "returns empty String" do
          result.should == ""
        end

      end

    end

    context "given multiple paragraphs, wrapped in a div" do

      let(:input) { "<div><p>One two three.</p> <p>Four five six.</p></div>" }

      context "with max-length shorter than input" do

        let(:max_words) { total_words - 1 }

        it "drops elements until beneath max-length" do
          result.should == "<div><p>One two three.</p></div>"
        end

      end

    end

  end

end
