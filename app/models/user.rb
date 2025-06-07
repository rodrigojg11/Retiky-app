class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :tickets, dependent: :destroy
  has_many :orders, dependent: :destroy
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  enum role: { customer: "customer", company: "company" }

  validates :role, presence: true
  # validates :first_name, :last_name, :role, presence: true
end
