class OperationalDistrictsController < ApplicationController
  before_action :set_operational_district, only: [:edit, :update, :destroy]

  def index
    @operational_districts = OperationalDistrict.search(params).page(params[:page])
  end

  def new
    @operational_district = OperationalDistrict.new
  end

  def edit
  end

  def create
    @operational_district = OperationalDistrict.new(operational_district_params)

    if @operational_district.save
      redirect_to operational_districts_url, notice: 'Operational district was successfully created.'
    else
      render :new 
    end
  end

  def update
    if @operational_district.update(operational_district_params)
      redirect_to operational_districts_url, notice: 'Operational district was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @operational_district.destroy
    redirect_to operational_districts_url, notice: 'Operational district was successfully destroyed.'
  end

  private
    def set_operational_district
      @operational_district = OperationalDistrict.find(params[:id])
    end

    def operational_district_params
      params.require(:operational_district).permit(:name, :code, :external_id, :enable_reminder)
    end
end
