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

RSpec.describe 'プロトタイプの詳細ページ', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
  end
  it 'ログインユーザーが投稿したプロトタイプの詳細ページに編集・削除ボタンが表示される' do
    # プロトタイプを投稿したユーザーでサインインする
    visit new_user_session_path
    fill_in 'メールアドレス', with: @prototype.user.email
    fill_in 'パスワード（6文字以上）', with: @prototype.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
    # 詳細ページに遷移する
    visit prototype_path(@prototype)
    # 編集する・削除ボタンがあることを確認
    expect(page).to have_content('編集する')
    expect(page).to have_content('削除する')
    # 詳細ページにプロトタイプの内容が含まれている
    expect(page).to have_content("#{@prototype.title}")
    expect(page).to have_content("#{@prototype.catch_copy}")
    expect(page).to have_content("#{@prototype.concept}")
    expect(page).to have_selector('img')
    # コメント用のフォームが存在する
    expect(page).to have_selector 'form'
  end
  it 'ログインユーザーが投稿していないプロトタイプの詳細ページに編集・削除ボタンが表示されない' do
    # プロトタイプを投稿したユーザーでサインインする
    sign_in(@user)
    # 詳細ページに遷移する
    visit prototype_path(@prototype)
    # 編集する・削除ボタンがないことを確認
    expect(page).to have_no_content('編集する')
    expect(page).to have_no_content('削除する')
    # 詳細ページにプロトタイプの内容が含まれている
    expect(page).to have_content("#{@prototype.title}")
    expect(page).to have_content("#{@prototype.catch_copy}")
    expect(page).to have_content("#{@prototype.concept}")
    expect(page).to have_selector('img')
    # コメント用のフォームが存在する
    expect(page).to have_selector 'form'
  end
end

RSpec.describe 'プロトタイプ編集', type: :system do
    before do
      @prototype1 = FactoryBot.create(:prototype)
      @prototype2 = FactoryBot.create(:prototype)
    end
    context 'ツイート編集ができるとき' do
      it 'ログインしたユーザーは自分が投稿したツイートの編集ができる' do
        # ツイート1を投稿したユーザーでログインする
        visit new_user_session_path
        fill_in 'メールアドレス', with: @prototype1.user.email
        fill_in 'パスワード（6文字以上）', with: @prototype1.user.password
        find('input[name="commit"]').click
        expect(current_path).to eq(root_path)
        # ツイート1に「編集」ボタンがあることを確認する
        expect(
          all('.more')[1].hover
        ).to have_link '編集', href: edit_prototypw_path(@prototype1)
        # 編集ページへ遷移する
        # すでに投稿済みの内容がフォームに入っていることを確認する
        # 投稿内容を編集する
        # 編集してもTweetモデルのカウントは変わらないことを確認する
        # 編集完了画面に遷移したことを確認する
        # 「更新が完了しました」の文字があることを確認する
        # トップページに遷移する
        # トップページには先ほど変更した内容のツイートが存在することを確認する（画像）
        # トップページには先ほど変更した内容のツイートが存在することを確認する（テキスト）
      end
    end
    context 'ツイート編集ができないとき' do
      it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
        # ツイート1を投稿したユーザーでログインする
        # ツイート2に「編集」ボタンがないことを確認する
      end
      it 'ログインしていないとツイートの編集画面には遷移できない' do
        # トップページにいる
        # ツイート1に「編集」ボタンがないことを確認する
        # ツイート2に「編集」ボタンがないことを確認する
      end
    end
end
