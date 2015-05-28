class OrganizationsController < ApplicationController

  def index
    @organizations = Organization.search({:list_orgs => current_user.get_organization_ids}).all.page(params[:page])
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find(params[:id])
    @settings = @organization.organization_setting
    unless @settings
      @settings = @organization.create_setting
    end
    @parameters = verboice_parameters @settings.project_id
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

  def update_settings
    @organization = Organization.find(params[:id])
    @settings = @organization.organization_setting
    @settings.update_attributes!( :project_id => params[:project], 
                                  :callflow_id => params[:call_flow],
                                  :schedule_id => params[:schedule]) if @settings
    render :edit
  end

  private

  def verboice_parameters project_id
    result = { channels: [], projects: [], call_flows: [], schedules: [] }

    begin
      result[:projects]   = Service::Verboice.connect().projects
      result[:call_flows] = Service::Verboice.connect().call_flows
      result[:schedules]  = Service::Verboice.connect().schedules(project_id) unless Setting[:project].blank?
    rescue JSON::ParserError
      flash.now.alert = " Failed to fetch some data from verboice"
    end

    result
  end

  def organization_params
    params.require(:organization).permit(:name, :ods => [])
  end

end
