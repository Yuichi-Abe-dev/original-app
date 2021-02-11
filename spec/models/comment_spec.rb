require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#create' do
    before do
      @comment = FactoryBot.build(:comment)
    end

    it 'commentが存在していれば保存できること' do
      expect(@comment).to be_valid
    end

    it 'userが紐付いていないと保存できないこと' do
      @comment.user = nil
      @comment.valid?
      expect(@comment.errors.full_messages).to include('User must exist')
    end

    it 'prototypeが紐付いていないと保存できないこと' do
      @comment.prototype = nil
      @comment.valid?
      expect(@comment.errors.full_messages).to include('Prototype must exist')
    end

  end
end
