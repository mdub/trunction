require 'trunction'

describe Trunction do

  let(:total_length) { Nokogiri::HTML::DocumentFragment.parse(input).text.length }
  let(:ellipsis) { "&#8230;" }

  include Trunction

  let(:min_length) { 1 }

  let(:result) do
    truncate_html(input, min_length, max_length).gsub("\n", '')
  end

  context "given multiple paragraphs" do

    let(:input) { "<p>one</p><p>two</p><p>three</p>" }

    describe "#truncate_html" do

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

end
