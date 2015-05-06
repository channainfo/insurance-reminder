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
    errors = validate_existing_od params[:organization]["ods"], nil
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
    errors = validate_existing_od params[:organization]["ods"], @organization.id
    if errors["status"]
      if @organization.update(organization_params)
        redirect_to organizations_url, notice: 'Organization was successfully updated.'
      else
        render :edit
      end
    else
      errors["errors"].each do |error|
        @organization.errors.add(:ods, error)
      end
      render :edit
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    if @organization.destroy!
      redirect_to organizations_url, notice: 'Organization was successfully destroyed.'
    else
      redirect_to organizations_url, errors: 'Organization was not successfully destroyed.'
    end
  end

  private
    def set_organization
      @operational_district = OperationalDistrict.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name, :ods => [])
    end

    def validate_existing_od ods, ignor_org_id
      orgs = Organization.where("id <> ?", ignor_org_id) if ignor_org_id.present?
      orgs = Organization.all unless ignor_org_id.present?
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
