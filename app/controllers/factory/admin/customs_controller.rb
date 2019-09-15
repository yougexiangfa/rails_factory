class Factory::Admin::CustomsController < Factory::Admin::BaseController
  before_action :set_custom, only: [:show, :edit, :update, :destroy]
  
  def index
    q_params = {}
    q_params.merge! default_params
    q_params.merge! params.permit(:product_id)
    #@product = Product.find params[:product_id]
    @customs = Custom.default_where(q_params).page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    @custom.assign_attributes(custom_params)

    unless @custom.save
      render :edit, locals: { model: @custom }, status: :unprocessable_entity
    end
  end

  def destroy
    @custom.destroy
  end

  private
  def set_custom
    @custom = Custom.find(params[:id])
  end

  def custom_params
    params.fetch(:custom, {}).permit(
      :name,
      :customer,
      :state,
      :qr_code,
      :ordered_at
    )
  end

end
