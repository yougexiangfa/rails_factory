module RailsFactory::GoodProvider
  extend ActiveSupport::Concern
  included do
    belongs_to :good, polymorphic: true
    belongs_to :provider

    validates :good_id, uniqueness: { scope: [:good_type, :provider_id] }

    scope :verified, -> { where(verified: true) }
  end
  
  def set_selected
    self.class.transaction do
      self.update!(selected: true)
      self.class.where.not(id: self.id).where(good_type: self.good_type, good_id: self.good_id).update_all(selected: false)
      good.update!(import_price: self.export_price)
    end
  end

end
