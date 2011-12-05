# encoding: utf-8

require 'trunction'

describe Trunction do

  let(:full_text) { Nokogiri::HTML::DocumentFragment.parse(input).text }
  let(:total_length) { full_text.length }
  let(:ellipsis) { "&#8230;" }

  include Trunction

  let(:result) do
    truncate_html(input, max_length).gsub("\n", '')
  end

  describe "#truncate_html" do

    context "given multiple paragraphs" do

      let(:input) { "<p>one</p><p>two</p><p>three</p>" }

      context "with max-length longer than input" do

        let(:max_length) { total_length + 1 }

        it "returns input intact" do
          result.should == input
        end

      end

      context "with max-length shorter than input" do

        let(:max_length) { total_length - 1 }

        it "drops elements until beneath max-length" do
          result.should == "<p>one</p><p>two</p>"
        end

      end

      context "with max-length shorter than first paragraph" do

        let(:max_length) { 1 }

        it "returns empty String" do
          result.should == ""
        end

      end

    end

    context "given multiple paragraphs, wrapped in a div" do

      let(:input) { "<div><p>one</p><p>two</p><p>three</p></div>" }

      context "with max-length shorter than input" do

        let(:max_length) { total_length - 1 }

        it "drops elements until beneath max-length" do
          result.should == "<div><p>one</p><p>two</p></div>"
        end

      end

    end

    context "a final paragraph with inline elements" do

      let(:input) { "<p>one</p><p>two</p><p><b>one</b>, <b>two</b>, <b>three</b>, <b>four</b></p>" }

      context "with max-length shorter than input" do

        let(:max_length) { total_length - 1 }

        it "drops the entire final paragraph" do
          result.should == "<p>one</p><p>two</p>"
        end

      end

    end

  end

end
