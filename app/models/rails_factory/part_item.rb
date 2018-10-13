class PartItem < ApplicationRecord
  attribute :state, :string, default: 'purchasing'

  belongs_to :part
  belongs_to :product_item, optional: true
  has_one_attached :qr_file

  enum state: {
    purchasing: 'purchasing',
    receiving: 'receiving',
    warehouse_in: 'warehouse_in',
    warehouse_out: 'warehouse_out',
    used: 'used'
  }

  after_initialize if: :new_record? do
    self.qr_code ||= UidHelper.nsec_uuid self.part&.qr_prefix
  end
  before_save :sync_qrcode, if: -> { qr_code_changed? }

  def sync_qrcode
    file = QrcodeHelper.code_file(qr_code)
    file.rewind
    self.qr_file.attach io: file, filename: qr_code
  end



end unless RailsFactory.config.disabled_models.include?('PartItem')
