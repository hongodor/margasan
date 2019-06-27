class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :projects
  has_many :chapters
  has_many :options, -> { order('created_at DESC').limit(5)  }
  enum role: [:user, :admin]

  validates :username, presence: true


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
