class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :projects
  enum role: [:user, :admin]

  validates :username, presence: true
  before_create(:set_default_role, { if: :new_record? })


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def set_default_role
    self.role ||= :admin
  end

end
