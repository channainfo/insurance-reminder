# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/tmp/insurance_reminder/cron_log.log"

# run this task only on servers with the :app role in Capistrano
# see Capistrano roles section below
every :hour, :roles => [:app] do
  rake "shpa:import_beneficiaries_expired"
  rake "shpa:call_records_expired"
  rake "shpa:update_delay_call_as_error"
end
