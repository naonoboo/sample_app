require 'rails_helper'
require 'spec_helper'
require 'rspec/rails'
include ApplicationHelper
include SessionsHelper

describe "Authenticaion" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_title('Sign in') }
			# it { should have_selector('div.alert.alert-error', text: 'Invalid') }
			it { should have_error_message('Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid infromation" do
			let(:user) { FactoryGirl.create(:user) }
			# signin_in では正しく動作しないため、test_signin_in に変更
			before { test_sign_in user}
			#before do
			  #	fill_in "Email", with: user.email.upcase
			  #	fill_in "Password", with: user.password
			  #	click_button "Sign in"
			# end
			# before { valid_signin(user) }

			it { should have_title(user.name) }
			it { should have_link('Users', href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when attemptin to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Email", with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				describe "after sigining in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end
				end
			end

			describe "in the Users Controller" do
				
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "visting the user index" do
					before { visit users_path }
					it { should have_title('Sign in') }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { test_sign_in user, no_capybara: true }

			describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_path) }
			end

			describe "submitting a PATCH request to the User#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { test_sign_in non_admin, no_capybara: true}

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_path) }
			end
		end
	end
end
