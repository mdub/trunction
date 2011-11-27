require 'trunction'

describe Trunction do

  let(:total_length) { Nokogiri::HTML::DocumentFragment.parse(input).text.length }
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

    context "a single paragraph with inline elements" do

      let(:input) { "<p><b>one</b>, <b>two</b>, <b>three</b>, <b>four</b></p>" }

      context "with max-length shorter than input" do

        let(:max_length) { total_length - 1 }

        it "drops the last word" do
          result.should == "<p><b>one</b>, <b>two</b>, <b>three</b>, </p>"
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
