require 'rails_helper'

RSpec.describe "プロトタイプ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
  end

  context '投稿画面への遷移' do
    it 'ログインユーザーでないと投稿画面へ遷移ができない' do
      # トップページに遷移する
      visit root_path
      #新規投稿ボタンをクリック
      expect(page).to have_no_content('New Proto')
    end
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
      # 投稿した内容がブラウザに表示されていることを確認する
      expect(page).to have_content("#{@prototype.title}")
      expect(page).to have_content("#{@prototype.catch_copy}")
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
  it '画像をクリックすると詳細ページへ遷移' do
    # プロトタイプを投稿したユーザーでサインインする
    sign_in(@user)
    # 詳細ページに遷移する
    find(".card__img").click
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
    @prototype = FactoryBot.create(:prototype)
  end
  context '編集画面への遷移' do
    it '投稿したユーザーでないと編集画面へ遷移ができない' do
      @user = FactoryBot.create(:user)
      #プロトタイプを投稿したユーザーとは別のユーザーがサインイン
      sign_in(@user)
      # 詳細ページに遷移する
      visit prototype_path(@prototype)
      #編集ボタンが存在しないことを確認
      expect(page).to have_no_content('編集する')
    end
  end
  context 'プロトタイプを編集できるとき' do
    it 'ログインしたユーザーは自分が投稿したプロトタイプの編集ができる' do
      # プロトタイプを投稿したユーザーでサインインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @prototype.user.email
      fill_in 'パスワード（6文字以上）', with: @prototype.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # 編集ページへ遷移する
      click_on ('編集する')
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#prototype_title').value # prototype_titleというid名が付与された要素の値を取得
      ).to eq(@prototype.title)
      expect(
        find('#prototype_catch_copy').value # catch_copyというid名が付与された要素の値を取得
      ).to eq(@prototype.catch_copy)
      expect(
        find('#prototype_concept').value # prototype_conceptというid名が付与された要素の値を取得
      ).to eq(@prototype.concept)
      # 投稿内容を編集する
      fill_in 'prototype_title', with: "#{@prototype.title}+編集で追加"
      fill_in 'prototype_catch_copy', with: "#{@prototype.catch_copy}+編集で追加"
      fill_in 'prototype_concept', with: "#{@prototype.concept}+編集で追加"
      # 編集してもプロトタイプモデルのカウントは変わらないことを確認する
      expect{
         find('input[name="commit"]').click
      }.to change { Prototype.count }.by(0)
      # 編集完了画面に遷移したことを確認する
      expect(current_path).to eq(prototype_path(@prototype))
      # トップページに遷移する
      visit root_path
      # トップページには先ほど変更した内容のプロトタイプが存在することを確認する
      expect(page).to have_content("#{@prototype.title}+編集で追加")
      expect(page).to have_content("#{@prototype.catch_copy}+編集で追加")
      expect(page).to have_selector('img')
    end
  end
  context 'プロトタイプの編集に失敗したとき' do
    it 'ログインしたユーザーは自分が投稿したプロトタイプの編集ができる' do
      # プロトタイプを投稿したユーザーでサインインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @prototype.user.email
      fill_in 'パスワード（6文字以上）', with: @prototype.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # 編集ページへ遷移する
      click_on ('編集する')
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#prototype_title').value # prototype_titleというid名が付与された要素の値を取得
      ).to eq(@prototype.title)
      expect(
        find('#prototype_catch_copy').value # catch_copyというid名が付与された要素の値を取得
      ).to eq(@prototype.catch_copy)
      expect(
        find('#prototype_concept').value # prototype_conceptというid名が付与された要素の値を取得
      ).to eq(@prototype.concept)
      # 投稿内容を編集する
      fill_in 'prototype_title', with: ""
      fill_in 'prototype_catch_copy', with: "#{@prototype.catch_copy}+編集で追加"
      fill_in 'prototype_concept', with: "#{@prototype.concept}+編集で追加"
      # 編集してもプロトタイプモデルのカウントは変わらないことを確認する
      expect{
         find('input[name="commit"]').click
      }.to change { Prototype.count }.by(0)
      # 詳細ページにとどまることを確認する
      expect(current_path).to eq(prototype_path(@prototype))
      # トップページに遷移する
      visit root_path
      # トップページには編集前のプロトタイプが存在することを確認する
      expect(page).to have_content("#{@prototype.title}")
      expect(page).to have_content("#{@prototype.catch_copy}")
      expect(page).to have_selector('img')
    end
  end
end

RSpec.describe 'プロトタイプ削除', type: :system do
  before do
    @prototype = FactoryBot.create(:prototype)
  end
  context 'プロトタイプの削除を行うこと' do
    it 'ログインしたユーザーは自分が投稿したプロトタイプを削除できる' do
      # プロトタイプを投稿したユーザーでサインインする
      visit new_user_session_path
      fill_in 'メールアドレス', with: @prototype.user.email
      fill_in 'パスワード（6文字以上）', with: @prototype.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # 削除ボタンをクリックするとプロトタイプモデルのカウントが減ること確認
      expect{
        click_on('削除する')
      }.to change { Prototype.count }.by(-1)
      # 削除後にトップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど削除した内容のプロトタイプが存在しないことを確認する
      expect(page).to have_no_content("#{@prototype.title}")
      expect(page).to have_no_content("#{@prototype.catch_copy}")
    end
  end
end