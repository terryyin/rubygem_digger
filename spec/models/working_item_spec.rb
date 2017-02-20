require 'rails_helper'

RSpec.describe WorkingItem, type: :model do
  describe '#regenerate' do
    before { allow_any_instance_of(RubygemDigger::Digger).to receive(:dig).and_yield('1', '2', 3) }

    subject { WorkingItem.regenerate }
    it { expect { subject }.to change(WorkingItem, :count).by 1 }

    context 'when the same job exist' do
      before { WorkingItem.create work_type: '1', content: '2', version: 3 }

      it { expect { subject }.to change(WorkingItem, :count).by 0 }
    end
  end
end
