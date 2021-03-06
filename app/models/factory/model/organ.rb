module Factory
  module Model::Organ
    extend ActiveSupport::Concern

    included do
      belongs_to :area, optional: true

      has_many :part_providers
      has_many :parts, through: :part_providers
      has_many :good_providers, foreign_key: :provider_id, dependent: :delete_all
    end

    def name_detail
      "#{name} (#{id})"
    end

  end
end
