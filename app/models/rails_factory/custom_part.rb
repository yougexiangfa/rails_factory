class CustomPart < ApplicationRecord
  belongs_to :product
  belongs_to :part

end unless RailsFactory.config.disabled_models.include?('CustomPart')