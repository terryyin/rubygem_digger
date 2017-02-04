require "spec_helper"
require 'pathname'

describe RubygemDigger::Cacheable do
  class MyCacheable
    include RubygemDigger::Cacheable
    self.version = 6

    def initialize
      @abc = 5
    end

    def create(context)
    end
  end

  before {MyCacheable.invalidate}

  describe '#load_or_create' do
    subject {MyCacheable.load_or_create({})}
    it{is_expected.to be_a MyCacheable}

    context 'when creating set instance vars' do
      before do
        allow_any_instance_of(MyCacheable).to receive(:create) do |my|
          my.instance_variable_set(:@abc, 1)
        end
      end
      it 'should call the crearte' do
        expect(subject.instance_variable_get(:@abc)).to eq 1
      end

      context 'when object is flushed' do
        before {subject}
        let(:another) {MyCacheable.load_or_create({})}
        it 'should not call create' do
          expect_any_instance_of(MyCacheable).not_to receive(:create)
          another
        end

        it 'should call the crearte' do
          expect(another.instance_variable_get(:@abc)).to eq 1
        end
      end
    end

  end
  describe 'collection' do
    subject {MyCacheable.all}
    its(:size) {is_expected.to eq 0}
  end

  describe 'an object' do
    subject {MyCacheable.new}

  end

end


