module Factory
  module Model::PartProvider
    extend ActiveSupport::Concern

    included do
      attribute :export_price, :decimal
      attribute :verified, :boolean, default: false
      attribute :selected, :boolean

      belongs_to :part, inverse_of: :part_providers, counter_cache: true
      belongs_to :product  # 对应供应链产品
      belongs_to :production  # 对应供应链产品型号
      belongs_to :provider, class_name: 'Organ'
      belongs_to :organ

      validates :part_id, uniqueness: { scope: [:provider_id] }

      scope :verified, -> { where(verified: true) }

      before_validation :sync_from_production, if: -> { production && production_id_changed? }
      before_save :sync_to_part, if: -> { production && production_id_changed? }
      after_save :sync_price_to_part, if: -> { selected? && saved_change_to_selected? }
    end

    def sync_from_production
      self.product_id = production.product_id
      self.export_price = production.price
      self.provider_id = product.organ_id
      self.organ = part.organ || product.organ
    end

    def sync_to_part
      part.name = production.name
    end

    def set_selected
      self.class.transaction do
        self.class.where.not(id: self.id).where(part_id: self.part_id).update_all(selected: false)
      end
    end

    def sync_price_to_part
      part.import_price = self.export_price
      part.save
    end

  end
end
