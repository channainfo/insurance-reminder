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
    ods = ods.where(['code in (?)', options[:list_code]]) if options[:list_code].present?
    ods
  end

  def self.enables
    search(enable_reminder: true)
  end

  def self.import_from_table table_name
    sql = "select * from #{table_name}"
    objects = ActiveRecord::Base.connection.execute(sql)
    objects.each do |obj|
      OperationalDistrict.create!({:name => obj[2], :code => obj[1], :external_id => obj[0]})
    end
    drop_sql = "drop table #{table_name}"
    ActiveRecord::Base.connection.execute(drop_sql)
  end
end
