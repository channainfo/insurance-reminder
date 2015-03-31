class User < ActiveRecord::Base
  has_secure_password(validations: false)

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true

  validates :password, presence: true
  validates :password, confirmation: true

  before_save :downcase_username!

  ROLE_ADMIN = "Admin"
  ROLE_USER = "User"
  ROLE_OPERATOR = "Operator"

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

  private

  def downcase_username!
    self.username.downcase!
  end

end
