class Organization < ActiveRecord::Base
  validates :name, :ods, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  serialize :ods, Array

  before_validation :uniqueness_ods

  def self.except(org_id)
    org_id.nil? ? all : where("id != ?", org_id)
  end

  def self.search options={}
  	orgs = where("1=1")
    orgs = orgs.where(['name = ?', options[:name]]) if options[:name].present?
    orgs = orgs.where(['id in (?)', options[:list_orgs]]) if options[:list_orgs].present?
    orgs
  end

  private
  def uniqueness_ods
    organizations = Organization.except(id)
    organizations.each do |organization|
      ods.each do |od_id|
        if organization.ods.include? od_id
            existing_od = OperationalDistrict.find(od_id)
            errors.add(:ods, "#{existing_od.name} was owned by #{organization.name}")
          end
      end
    end
  end

end
