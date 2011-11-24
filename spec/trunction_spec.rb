require 'trunction'

describe Trunction do

  let(:p) { ["paragraph one", "paragraph two"] }
  let(:input) { p.map { |text| "<p>#{text}</p>" }.join("\n") }
  let(:total_length) { Nokogiri::HTML::DocumentFragment.parse(input).text.length }
  let(:ellipsis) { "&#8230;" }

  include Trunction

  describe "#truncate_html" do

    context "with limit longer than input" do

      it "returns input intact" do
        truncate_html(input, total_length + 1).should == input
      end

    end

  end

end
