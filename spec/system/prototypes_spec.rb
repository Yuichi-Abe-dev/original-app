require 'rails_helper'

RSpec.describe "プロトタイプ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、投稿に失敗すること' do
      # サインインする
      sign_in(@user)
      #新規投稿ボタンをクリック
      click_on ('New Proto')
      # DBに保存されていないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Prototype.count }.by(0)
      # 元のページに戻ってくることを確認する
      expect(page).to have_content('新規プロトタイプ投稿')
      #expect(current_path).to eq(new_prototype_path)
      #expect(current_path).to eq(root_path)
    end
  end

  context '投稿に成功したとき' do
    it 'フォームに値を入力し投稿に成功すること' do
      # サインインする
      sign_in(@user)
      #新規投稿ボタンをクリック
      click_on ('New Proto')
      #フォームに情報を入力
      fill_in 'プロトタイプの名称', with: @prototype.title
      fill_in 'キャッチコピー', with: @prototype.catch_copy
      fill_in 'コンセプト', with: @prototype.concept
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/400x400_01.png')
      #画像の投稿
      attach_file('prototype[image]', image_path, make_visible: true)
      # DBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Prototype.count }.by(1)
      # トップページにページに戻ってくることを確認する
      expect(current_path).to eq(root_path)
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
    end
  end

end
