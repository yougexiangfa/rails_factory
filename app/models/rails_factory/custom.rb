module RailsFactory::Custom
  extend ActiveSupport::Concern

  included do
    attribute :qr_code, :string
    attribute :ordered_at, :datetime
    attribute :price, :decimal, precision: 10, scale: 2, default: 0
    attribute :state, :string, default: 'init'

    belongs_to :organ, optional: true
    belongs_to :product
    belongs_to :cart
    has_many :custom_parts, dependent: :destroy
    has_many :parts, through: :custom_parts

    has_one_attached :logo

    enum state: {
      init: 'init',
      checked: 'checked',
      carted: 'carted'
    }

    after_initialize if: :new_record? do
      if product_id && part_ids.blank?
        self.part_ids = product.part_ids
      end
      compute_sum
      if product
        self.organ_id = product.organ_id if defined? :organ_id
        self.name ||= product.name
        self.logo.attach product.logo_blob
      end
    end
    before_validation :compute_sum
  end

  def compute_sum
    self.custom_parts.each(&:sync_amount)
    self.price = custom_parts.sum(&:price)
  end

end
