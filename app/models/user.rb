class User < ActiveRecord::Base
  has_secure_password(validations: false)

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true

  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  attr_accessor :old_password

  validates :organizations, presence: true, if: :operator?
  validates :ods, presence: true, if: :user?

  before_save :downcase_username!

  ROLE_ADMIN = "Admin"
  ROLE_USER = "User"
  ROLE_OPERATOR = "Operator"

  serialize :organizations, Array
  serialize :ods, Array

  def reset_password_to new_password
    self.password = new_password

    save
  end

  def change_password old_password, new_password, new_password_confirmation
    if self.authenticate(old_password)
      self.password = new_password
      self.password_confirmation = new_password_confirmation

      save
    else
      errors.add(:old_password, 'does not matched')
      false
    end
  end

  def self.authenticate(username, password)
    user = User.find_by!(username: username.downcase)
    user.authenticate(password)
  rescue ActiveRecord::RecordNotFound => e
    false
  end

  def admin?
    role == ROLE_ADMIN
  end

  def user?
    role == ROLE_USER
  end

  def operator?
    role == ROLE_OPERATOR
  end

  def self.except(user)
    where(["id != ?", user.id])
  end

  def self.except_role role
    where(['role != ?', role])
  end

  def editable? user
    if self.role == ROLE_ADMIN
      if id == user.id
        return false
      else
        if user.role == ROLE_USER
          return false
        else
          return true
        end
      end
    elsif self.role == ROLE_OPERATOR
      return true
    else
      return false
    end
  end

  def get_organization_ids
    orgs = get_organizations
    unless role == ROLE_USER
      return orgs.pluck(:id)
    else
      return []
    end
  end

  def get_organizations
    if self.role == ROLE_ADMIN
      orgs = Organization.all
    elsif self.role == ROLE_OPERATOR
      orgs = Organization.where("id in (?)",self.organizations)
    else
      orgs = Organization.all.select { |m| m.ods.include? self.ods.first}
    end
    return orgs
  end

  def get_ods_id
    get_ods.pluck(:id)
  end

  def get_ods_external_code
    return get_ods.pluck(:external_id)
  end

  def get_ods_code
    return get_ods.pluck(:code)
  end

  def get_ods
    if self.role == ROLE_ADMIN
      ods = OperationalDistrict.all
    elsif self.role == ROLE_OPERATOR
      org = Organization.find self.organizations.first
      ods = OperationalDistrict.where("id in (?)",org.ods)
    else
      ods = OperationalDistrict.where("id in (?)",self.ods)
    end
  end

  def self.get_involved_users user
    if user.role == ROLE_ADMIN
      users = User.except_role ROLE_USER
    elsif user.role == ROLE_OPERATOR
      orgs = Organization.find user.organizations.first
      users = []
      operators = User.all.select { |m| m.organizations.include? orgs.id.to_s }
      users.concat operators
      od_users = []
      orgs.ods.each do |od|
        one_od_users = User.all.select { |m| m.ods.include? od}
        od_users.concat one_od_users unless od_users.include? one_od_users.first
      end
      users.concat od_users
    else
      users = []
    end
    return users
  end

  def get_roles
    return [User::ROLE_ADMIN, User::ROLE_OPERATOR] if admin?
    return [User::ROLE_USER, User::ROLE_OPERATOR] if operator?
  end

  def is?(user)
    self.id == user.id
  end
  
  private

  def downcase_username!
    self.username.downcase!
  end

end
