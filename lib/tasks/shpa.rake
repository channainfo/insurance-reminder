namespace :shpa do
  desc "Get all client who those are expired"
  task import_beneficiaries_expired: :environment do

    od_ids = OperationalDistrict.enables.map(&:external_id)

    Client.import_shpa_beneficiaries_expired_between_in_od od_ids unless od_ids.empty?
  end

  desc "Update pending call as error"
  task update_delay_call_as_error: :environment do
    Call.mark_delay_as_error_before! 1.hours.ago
  end

  desc "call the record that expired"
  task call_records_expired: :environment do
    Call.call_records_expired
  end

  desc "import operational district"
  task import_od: :environment do
    OperationalDistrict.import_from_table("tu_operational_district")
  end
end
