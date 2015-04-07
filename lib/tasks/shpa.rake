namespace :shpa do
  desc "Get all client who those are expired"
  task import_beneficiaries_expired: :environment do
    from_date = Date.today
    to_date = from_date + (Setting[:pending_call_day].to_i - 1).days

    od_ids = OperationalDistrict.enables.map(&:external_id)

    Client.import_shpa_beneficiaries_expired_between_in_od from_date, to_date, od_ids unless od_ids.empty?
  end

  desc "Update pending call as error"
  task update_delay_call_as_error: :environment do
    Call.mark_delay_as_error_before! 1.hours.ago
  end

  desc "call the record that expired"
  task call_records_expired: :environment do
    from_date = Date.today
    to_date = from_date + (Setting[:day_before_expiration_date].to_i - 1).days
    Call.call_records_expired from_date, to_date
  end

  desc "import operational district"
  task import_od: :environment do
    OperationalDistrict.import_from_table("tu_operational_district")
  end
end
