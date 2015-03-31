class Service::Verboice

  def self.auth email, password
    auth_url = "#{ENV['VERBOICE_URL']}/auth"
    response = Typhoeus.post(auth_url, body: { account: { email: email, password: password } })
    response.success? ? JSON.parse(response.body) : nil
  end

  def self.connect
    @@instance ||= self.new(Setting[:verboice_email], Setting[:verboice_token])
  end

  def initialize(email, token)
    @email = email
    @token = token
  end

  def bulk_enqueue!(calls)
    options = calls.map { |call| call.to_verboice_params if call.status != Call::STATUS_DISABLED }
    response = post("/bulk_call", {call: options})
    call_response = JSON.parse(response.body)
    call_response.each_with_index do |call_attrs, index|
      call = calls[index]
      call.status = Call::STATUS_PENDING
      call.verboice_call_id = call_attrs['call_id']
      call.save!
    end
  end

  def retry_enqueue! main_call

    retry_call = Call.new(expiration_date: main_call.expiration_date,
                          phone_number: main_call.phone_number,
                          family_code: main_call.family_code,
                          status: Call::STATUS_ERROR,
                          client_id: main_call.try(:client).try(:id),
                          kind: Call::KIND_MANUAL,
                          main: main_call)

    retry_call.save
    main_call.status = Call::STATUS_ERROR
    main_call.save!

    enqueue!(retry_call)

    main_call.status = Call::STATUS_PENDING
    main_call.save!
  end

  def enqueue! call
    options = call.to_verboice_params
    response = post("/call", {call: options})

    verboice_call = JSON.parse(response.body)

    call.status = Call::STATUS_PENDING
    call.verboice_call_id = verboice_call['call_id']
    call.save!
  end

  def channels
    get('/channels')
  end

  def projects
    get('/projects')
  end

  def call_flows
    get('/call_flows')
  end

  def schedules(project_id)
    get("/projects/#{project_id}/schedules")
  end

  private

  def get(path)
    response = Typhoeus.get( build_url(path), body: JSON.generate(auth_params), headers: {'content-type' => 'application/json'} )
    JSON.parse(response.response_body)
  end

  def post(path, params)
    Typhoeus.post(build_url(path), body: JSON.generate(auth_params(params)), headers: {'content-type' => 'application/json'} )
  end

  def build_url(path)
    ENV['VERBOICE_URL'] + path
  end

  def auth_params(params = {})
    params.merge({ email: @email, token: @token })
  end
end
