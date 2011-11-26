require 'trunction'

describe Trunction do

  let(:paragraphs) { ["paragraph one", "paragraph two"] }
  let(:input) { paragraphs.map { |text| p(text) }.join }
  let(:total_length) { Nokogiri::HTML::DocumentFragment.parse(input).text.length }
  let(:ellipsis) { "&#8230;" }

  def p(text)
    "<p>#{text}</p>"
  end

  include Trunction

  describe "#truncate_html" do

    let(:min_length) { 1 }

    let(:result) do
      truncate_html(input, min_length, max_length)
    end

    context "with max-length longer than input" do

      let(:max_length) { total_length + 1 }

      it "returns input intact" do
        result.should == input
      end

    end

    context "with max-length shorter than input" do

      let(:max_length) { total_length - 1 }

      context "and liberal min-length" do

        let(:min_length) { total_length - 1 }

        it "drops elements until beneath max-length" do
          result.should == p(paragraphs.first)
        end

      end

    end

  end

end
