require 'rails_helper'

RSpec.describe "プロトタイプ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
    @comment = Faker::Lorem.sentence
  end

  context 'コメントが投稿できることの確認' do
    it 'ログインしたユーザーはツイート詳細ページでコメント投稿できる' do
      # ログインする
      sign_in(@user)
      # 詳細ページに遷移する
      visit prototype_path(@prototype)
      # フォームに情報を入力する
      fill_in 'comment_text', with: @comment
      # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Comment.count }.by(1)
      # 詳細ページにリダイレクトされることを確認する
      expect(current_path).to eq(prototype_path(@prototype))
      # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
      expect(page).to have_content @comment
    end
  end

  context 'ログインしていないユーザーはコメントが投稿できないことの確認' do
    it 'ログインしたユーザーはプロトタイプ詳細ページでコメント投稿フォームが表示されない' do
      # 詳細ページに遷移する
      visit prototype_path(@prototype)
      # フォームが存在しないことを確認
      expect(page).to have_no_content('送信する')
      # 詳細ページにコメントが追加されないことを確認する
      expect(page).to have_no_content @comment
    end
  end

  context 'コメントが投稿が失敗することの確認' do
    it 'コメントのフォームの情報に不足があると投稿に失敗する' do
      # ログインする
      sign_in(@user)
      # 詳細ページに遷移する
      visit prototype_path(@prototype)
      # フォームに情報を入力する
      fill_in 'comment_text', with: ''
      # コメントを送信すると、Commentモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Comment.count }.by(0)
      # 詳細ページにリダイレクトされることを確認する
      #expect(current_path).to eq(prototype_path(@prototype))
    end
  end
end