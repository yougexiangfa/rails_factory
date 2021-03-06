module Factory
  module Model::ProductPartTaxon
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :min_select, :integer, default: 1
      attribute :max_select, :integer, default: 1, comment: '最大同时选择，1则为单选'

      belongs_to :product
      belongs_to :part_taxon
      has_many :product_parts, foreign_key: :part_taxon_id, primary_key: :part_taxon_id
      has_many :parts, through: :product_parts

      has_taxons :part_taxon
    end

  end
end
