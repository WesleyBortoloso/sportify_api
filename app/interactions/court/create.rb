class Court::Create < BaseInteraction
  attr_reader :court

  def call
    create_court!

    court
  end

  private

  def create_court!
    @court = Court.create!(params)
  end
end
