module Factory
  class Admin::PartsController < Admin::BaseController
    before_action :set_part, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:name, :provider_id)

      # todo should order by part taxon position
      @parts = Part.default_where(q_params).order(part_taxon_id: :asc).page(params[:page])
    end

    def new
      @part = Part.new
    end

    def create
      @part = Part.new(part_params)

      unless @part.save
        render :new, locals: { model: @part }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @part.assign_attributes(part_params)

      unless @part.save
        render :edit, locals: { model: @part }, status: :unprocessable_entity
      end
    end

    def destroy
      @part.destroy
    end

    private
    def set_part
      @part = Part.find params[:id]
    end

    def part_params
      p = params.fetch(:part, {}).permit(
        :name,
        :qr_prefix,
        :import_price,
        :profit_price,
        :part_taxon_ancestors
      )
      p.merge! default_form_params
    end

  end
end
