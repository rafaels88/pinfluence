module Helpers
  def sign_in_on_dashboard
    user = create(:user)
    visit Admin.routes.new_session_path
    fill_in 'Email', with: user.email
    find('#session-password-plain').set user.password
    click_button 'Sign in'
  end
end
