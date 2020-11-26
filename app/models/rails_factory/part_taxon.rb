module RailsFactory::PartTaxon
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :position, :integer
    attribute :min_select, :integer, default: 1
    attribute :max_select, :integer, default: 1, comment: '最大同时选择，1则为单选'
    attribute :take_stock, :boolean, comment: '可盘点'

    belongs_to :organ, optional: true
    has_many :parts, dependent: :nullify

    acts_as_list
  end

end
