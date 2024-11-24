class User::Create < BaseInteraction
  attr_reader :user

  def call
    create_user!

    user
  end

  private

  def create_user!
    @user = User.create!(params)
  end
end
