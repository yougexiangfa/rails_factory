class Factory::Admin::PartsController < Factory::Admin::BaseController
  before_action :set_part, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit(:name, :provider_id)
    @parts = Part.page(params[:page])
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(part_params)

    if @part.save
      redirect_to admin_parts_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @part.update(part_params)
      redirect_to admin_parts_url
    else
      render :edit
    end
  end

  def destroy
    @part.destroy
    redirect_to admin_parts_url
  end

  private
  def set_part
    @part = Part.find(params[:id])
  end

  def part_params
    params.fetch(:part, {}).permit(
      :name,
      :qr_prefix,
      :import_price,
      :profit_price,
      :part_taxon_ancestors
    )
  end

end
