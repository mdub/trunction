require 'trunction'

describe Trunction do

  let(:paragraphs) { ["paragraph one", "paragraph two", "paragraph three"] }
  let(:input) { p(*paragraphs) }
  let(:total_length) { Nokogiri::HTML::DocumentFragment.parse(input).text.length }
  let(:ellipsis) { "&#8230;" }

  def p(*paragraphs)
    paragraphs.map { |text| "<p>#{text}</p>" }.join
  end

  include Trunction

  context "given multiple paragraphs" do

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

          let(:min_length) { 0 }

          it "drops elements until beneath max-length" do
            result.should == p(*paragraphs[0,2])
          end

        end

      end

    end

  end

end
