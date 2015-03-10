class OperationalDistrict < ActiveRecord::Base
  validates :code, :name, :external_id, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :external_id, uniqueness: true

  def self.search options = {}
    ods = where("1=1")
    ods = ods.where(['code = ?', options[:code]]) if options[:code].present?
    ods = ods.where(['name = ?', options[:name]]) if options[:name].present?
    ods = ods.where(['external_id = ?', options[:external_id]]) if options[:external_id].present?
    ods = ods.where(['enable_reminder = ?', options[:enable_reminder]]) if options[:enable_reminder].present?
    ods
  end
end
