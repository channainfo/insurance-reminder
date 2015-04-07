class OrganizationsController < ApplicationController

  def index
    @organizations = Organization.search({:list_orgs => current_user.get_organization_ids}).all.page(params[:page])
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(organization_params)
    errors = validate_existing_od params[:organization]["ods"]
    if errors["status"]
      if @organization.save
        redirect_to organizations_url, notice: 'Organization was successfully created.'
      else
        render :new 
      end
    else
      errors["errors"].each do |error|
        @organization.errors.add(:ods, error)
      end
      render :new
    end
    
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(organization_params)
      redirect_to organizations_url, notice: 'Operational district was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Operational district was successfully destroyed.'
  end

  private
    def set_organization
      @operational_district = OperationalDistrict.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name, :ods => [])
    end

    def validate_existing_od ods
      orgs = Organization.all
      result = {}
      result["errors"] = []
      result["status"] = true
      orgs.each do |u|
        ods.each do |o|
          if u.ods.include? o
            od = OperationalDistrict.find(o.to_i)
            result["errors"].push(" #{od.name} was owned by #{u.name}")
            result["status"] = false
          end
        end
      end
      return result
    end

end
