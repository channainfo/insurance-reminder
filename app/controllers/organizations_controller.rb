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
    if @organization.save
      redirect_to organizations_url, notice: 'Organization was successfully created.'
    else
      render :new
    end
  end

  def update
    @organization = Organization.find(params[:id])

    @organization.ods = [] unless params[:organization][:ods].present?

    if @organization.update(organization_params)
      redirect_to organizations_url, notice: 'Organization was successfully updated.'
    else
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

  def organization_params
    params.require(:organization).permit(:name, :ods => [])
  end

end
