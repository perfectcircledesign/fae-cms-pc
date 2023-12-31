require 'rails_helper'

describe Fae::User do

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:role_id) }
  it { should validate_confirmation_of(:password).with_message('does not match Password') }

  describe '#public_users' do
    it 'should assign public users' do
      super_admin = FactoryBot.create(:fae_role, name: 'super admin')
      admin = FactoryBot.create(:fae_role, name: 'admin')
      user = FactoryBot.create(:fae_role, name: 'user')
      super_user = FactoryBot.create(:fae_user, first_name: 'Andy', role: super_admin)
      admin_user = FactoryBot.create(:fae_user, first_name: 'Barbara', role: admin)
      user_user = FactoryBot.create(:fae_user, first_name: 'Cory', role: user)

      expect(Fae::User.public_users).to eq([admin_user, user_user])
    end
  end

  describe '.super_admin?' do
    it 'should return true when user is a super admin' do
      super_admin = FactoryBot.build_stubbed(:fae_role, name: 'super admin')
      super_user = FactoryBot.build_stubbed(:fae_user, role: super_admin)

      expect(super_user.super_admin?).to eq(true)
    end

    it 'should return false when user is not a super admin' do
      admin = FactoryBot.build_stubbed(:fae_role, name: 'admin')
      user = FactoryBot.build_stubbed(:fae_user, role: admin)

      expect(user.super_admin?).to eq(false)
    end
  end

  describe '.admin?' do
    it 'should return true when user is a super admin' do
      super_admin = FactoryBot.build_stubbed(:fae_role, name: 'super admin')
      super_user = FactoryBot.build_stubbed(:fae_user, role: super_admin)

      expect(super_user.admin?).to eq(false)
    end

    it 'should return false when user is not a super admin' do
      admin = FactoryBot.build_stubbed(:fae_role, name: 'admin')
      user = FactoryBot.build_stubbed(:fae_user, role: admin)

      expect(user.admin?).to eq(true)
    end
  end

  describe '.user?' do
    it 'should return true when user is a user' do
      user_role = FactoryBot.build_stubbed(:fae_role, name: 'user')
      user = FactoryBot.build_stubbed(:fae_user, role: user_role)

      expect(user.user?).to eq(true)
    end

    it 'should return false when user is not a user' do
      admin_role = FactoryBot.build_stubbed(:fae_role, name: 'admin')
      user = FactoryBot.build_stubbed(:fae_user, role: admin_role)

      expect(user.user?).to eq(false)
    end
  end

  describe '.super_admin_or_admin?' do
    it 'should return true when user is a super admin' do
      user_role = FactoryBot.build_stubbed(:fae_role, name: 'super admin')
      user = FactoryBot.build_stubbed(:fae_user, role: user_role)
      expect(user.super_admin_or_admin?).to eq(true)
    end

    it 'should return true when user is a admin' do
      user_role = FactoryBot.build_stubbed(:fae_role, name: 'admin')
      user = FactoryBot.build_stubbed(:fae_user, role: user_role)

      expect(user.super_admin_or_admin?).to eq(true)
    end

    it 'should return false when user is a user' do
      admin_role = FactoryBot.build_stubbed(:fae_role, name: 'user')
      user = FactoryBot.build_stubbed(:fae_user, role: admin_role)

      expect(user.super_admin_or_admin?).to eq(false)
    end
  end

  describe '.full_name' do
    it 'should return full name' do
      user = FactoryBot.build_stubbed(:fae_user, first_name: 'John', last_name: 'Doe')

      expect(user.full_name).to eq('John Doe')
    end
  end

  describe 'concerns' do
    it 'should allow instance methods through Fae::UserConcern' do
      user = FactoryBot.build_stubbed(:fae_user)
      expect(user.instance_says_what).to eq('Fae::User instance: what?')
    end

    it 'should allow class methods through Fae::UserConcern' do
      expect(Fae::User.class_says_what).to eq('Fae::User class: what?')
    end
  end

end
