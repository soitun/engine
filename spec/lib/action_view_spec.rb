require 'spec_helper'

describe ActionView::Base do
  describe '#escape_json' do
    let(:view) { ActionView::Base.new(ActionController::Base.view_paths, {}, nil) }

    it "should escape \u2028 characters" do
      expect(view.escape_json(%(unicode \342\200\250).force_encoding('UTF-8').encode!)).to eq %(unicode \u2028)
    end

    it "should escape \u2029 characters" do
      expect(view.escape_json(%(unicode \342\200\251).force_encoding('UTF-8').encode!)).to eq %(unicode \u2029)
    end
  end
end
