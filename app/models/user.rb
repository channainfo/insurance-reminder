class User < ActiveRecord::Base
  has_secure_password(validations: false)

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true

  validates :password, presence: true
  validates :password, confirmation: true


  before_save :downcase_username!

  def self.authenticate(username, password)
    user = User.find_by!(username: username.downcase)
    user.authenticate(password)
  rescue ActiveRecord::RecordNotFound => e
    false
  end

  private

  def downcase_username!
    self.username.downcase!
  end

end
