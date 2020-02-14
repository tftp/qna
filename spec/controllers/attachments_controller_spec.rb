require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question_author) { create(:question, user: author) }
  let(:question_user) { create(:question, user: user) }
  let(:answer_author) { create(:answer, question: question_user, user: author) }
  let(:answer_user) { create(:answer, question: question_user, user: user) }
  let(:file) { create_file_blob('rails_helper.rb') }

  describe 'DELETE #destroy' do
    context 'Unauthenticate user' do
      let!(:file_for_delete) do
        question_author.files.attach(file)
        question_author.files.last
      end

      it 'can not delete attached file from question' do

        expect { delete :destroy, params: { id: file_for_delete } }.to_not change(question_author.files, :count)
      end

      it 'redirect to sign in page if fail of questions file delete' do
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticate user deletes somebodys file' do
      before { login(author) }
      let!(:file_for_delete) do
        question_user.files.attach(file)
        question_user.files.last
      end

      it 'can not do it for somebodys question' do

        expect { delete :destroy, params: { id: file_for_delete } }.to_not change(question_user.files, :count)
      end

      it 'redirects to question view if fail of questions file delete' do
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to question_path(question_user)
      end
    end

    context 'Authenticate user deletes his file' do
      before { login(author) }
      let!(:file_for_delete) do
        question_author.files.attach(file)
        question_author.files.last
      end

      it 'can do it for his question' do

        expect { delete :destroy, params: { id: file_for_delete } }.to change(question_author.files, :count).by(-1)
      end

      it 'redirects to question view if questions file delete' do
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to question_path(question_author)
      end
    end
  end
end
