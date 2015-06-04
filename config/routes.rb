Rails.application.routes.draw do

  scope :api do
    get 'weather' => 'weather#current'
  end
end
