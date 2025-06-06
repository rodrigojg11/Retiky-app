class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  enum role: { customer: "customer", company: "company" }
  # has_many :tickets
  # has_many :orders

  validates :first_name, :last_name, :role, presence: true
end
