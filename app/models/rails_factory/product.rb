module RailsFactory::Product
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :description, :string
    attribute :qr_prefix, :string
    attribute :sku, :string, index: true
    attribute :order_items_count, :integer, default: 0
    attribute :published, :boolean, default: true
    attribute :str_part_ids, :string
    attribute :profit_margin, :decimal, precision: 4, scale: 2
    attribute :min_price, :decimal
    attribute :max_price, :decimal

    belongs_to :organ, optional: true
    belongs_to :product_taxon, optional: true

    has_one :production, -> { where(default: true) }
    has_many :productions, dependent: :destroy
    has_many :product_parts, dependent: :destroy
    has_many :parts, through: :product_parts
    has_many :product_part_taxons, dependent: :destroy
    has_many :part_taxons, through: :product_part_taxons
    has_many :product_plans, dependent: :destroy
    has_many :product_items, dependent: :destroy
    has_many :production_carts, dependent: :destroy
    has_many :carts, through: :production_carts

    accepts_nested_attributes_for :product_part_taxons, reject_if: :all_blank, allow_destroy: true

    has_one_attached :logo
    has_many_attached :covers
    has_many_attached :images

    has_taxons :product_taxon
  end

  def profit_margin_str
    (profit_margin * 100).to_s(:percentage)
  end

end
