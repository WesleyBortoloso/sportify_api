class Court::Update < BaseInteraction
  attr_reader :court

  def call
    fetch_court!
    update_court!

    court
  end

  private

  def update_court!
    court.update(params)
  end

  def fetch_court!
    @court ||= Court.find(params[:id])
  end
end
