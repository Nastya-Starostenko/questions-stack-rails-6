# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:request) { post :create, params: { question_id: question, answer: answer_params }, format: :js }
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in the db' do
        expect { request }.to change(Answer, :count).by(1)
      end

      it 'render create view' do
        request
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }
      let(:request_invalid) do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it 'do not save the answer' do
        expect { request_invalid }.not_to change(Answer, :count)
      end

      it 're-render create view' do
        request_invalid
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }
    let(:request) { patch :update, params: { id: answer, answer: answer_params }, format: :js }

    context 'with valid attributes' do
      let(:answer_params) { { body: 'new body' } }

      it 'changes answer attributes' do
        request

        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders updates view' do
        request
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:answer_params) { attributes_for(:answer, :invalid) }
      let!(:request_invalid) { patch :update, params: { id: answer, answer: answer_params }, format: :js }

      it 'does not change question attributes' do
        request_invalid
        expect do
          patch :update, params: { id: answer, answer: answer_params }, format: :js
        end.not_to change(answer, :body)
      end

      it 're-render edit view' do
        request_invalid
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    it 'deletes answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end
  end
end
