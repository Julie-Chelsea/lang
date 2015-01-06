require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "Example", username: "example_name", email: "exampl@example.com", password: "password123", password_confirmation: "password123")
	end

	test "should be valid" do
		assert @user.valid?
	end

	#presence test
	test "name should be present" do
		@user.name = "	"
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "	"
		assert_not @user.valid?
	end

	test "username should be present" do
		@user.username = "	"
		assert_not @user.valid?
	end

	test "password should be present" do
		@user.password = @user.password_confirmation = "	"
		assert_not @user.valid?
	end

	#length test
	test 'name should not be too long' do
		@user.name = "a" * 256
		assert_not @user.valid?
	end

	test 'email should not be too long' do
		@user.email = "a" * 500
		assert_not @user.valid?
	end

	test 'username should not be too long' do
		@user.username = "a" * 256
		assert_not @user.valid?
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	#email validations
	test 'email validation should accept valid addresses' do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email = valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end
	
	test 'email validation should reject invalid addresses' do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
		end
	end

	#email should be unique
	test 'email addresses should be unique' do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	#username should be unique
	test 'username should be unique' do
		duplicate_user = @user.dup
		@user.save
		assert_not duplicate_user.valid?
	end

end