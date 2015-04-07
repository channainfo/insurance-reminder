class Organization < ActiveRecord::Base
  validates :name, :ods, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  serialize :ods, Array

  def self.search options={}
  	orgs = where("1=1")
    orgs = orgs.where(['name = ?', options[:name]]) if options[:name].present?
    orgs = orgs.where(['id in (?)', options[:list_orgs]]) if options[:list_orgs].present?
    orgs
  end
end
