require 'rails_helper'
require 'json'

RSpec.describe WorkingItemsController, type: :controller do

  let(:working_item) {WorkingItem.create work_type: "a", content: "b", version: 0}
  describe 'regenerate' do
    subject {get :regenerate}
    before { expect(WorkingItem).to receive(:regenerate) }
    it{is_expected.to redirect_to "/"}
  end

  describe 'apply_job' do
    subject {post :apply_job}
    its(:body){is_expected.to eq '[]'}

    context 'when there is a work to do' do
      before {working_item}
      it {expect{subject}.to change{working_item.reload.working?}.to be_truthy}
      it {expect(JSON.parse(subject.body)).to include(a_hash_including({"id" => 1, "status" => 1, "work_type" => "a"})) }
    end

    context 'when there is a work already being worked' do
      before {working_item.update(status: WorkingItem::WORKING)}
      its(:body){is_expected.to eq '[]'}
    end
  end

  describe 'submit_job' do
    before {working_item}
    subject {post :submit_job, params:{id: working_item.id, working_item:{upload: File.new("afile","wb")}} }
    #its(:body){is_expected.to eq '"ok"'}
    #it {expect{subject}.to change(WorkingItem, :count).by(-1)}
  end
end
