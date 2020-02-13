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
      it 'can not delete attached file from question' do
        question_author.files.attach(file)
        file_for_delete = question_author.files.last

        expect { delete :destroy, params: { id: file_for_delete } }.to_not change(question_author.files, :count)
      end

      it 'can not delete attached file from answer' do
        answer_author.files.attach(file)
        file_for_delete = answer_author.files.last

        expect { delete :destroy, params: { id: file_for_delete } }.to_not change(answer_author.files, :count)
      end
    end

    context 'Authenticate user deletes file' do
      before { login(author) }

      it 'can do it for his question' do
        question_author.files.attach(file)
        file_for_delete = question_author.files.last

        expect { delete :destroy, params: { id: file_for_delete } }.to change(question_author.files, :count).by(-1)
      end

      it 'can not do it for somebodys question' do
        question_user.files.attach(file)
        file_for_delete = question_user.files.last

        expect { delete :destroy, params: { id: file_for_delete } }.to_not change(question_user.files, :count)
      end

      it 'can do it for his answer' do
        answer_author.files.attach(file)
        file_for_delete = answer_author.files.last

        expect { delete :destroy, params: { id: file_for_delete } }.to change(answer_author.files, :count).by(-1)
      end

      it 'can not do it for somebodys answer' do
        answer_user.files.attach(file)
        file_for_delete = answer_user.files.last

        expect { delete :destroy, params: { id: file_for_delete } }.to_not change(answer_user.files, :count)
      end

      it 'redirects to question view if answers file delete' do
        answer_author.files.attach(file)
        file_for_delete = answer_author.files.last
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to question_path(answer_author.question)
      end

      it 'redirects to question view if questions file delete' do
        question_author.files.attach(file)
        file_for_delete = question_author.files.last
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to question_path(question_author)
      end

      it 'redirects to question view if fail of answers file delete' do
        answer_user.files.attach(file)
        file_for_delete = answer_user.files.last
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to question_path(answer_user.question)
      end

      it 'redirects to question view if fail of questions file delete' do
        question_user.files.attach(file)
        file_for_delete = question_user.files.last
        delete :destroy, params: { id: file_for_delete }

        expect(response).to redirect_to question_path(question_user)
      end
    end
  end
end
