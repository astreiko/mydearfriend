class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :trackable, :omniauthable,
    omniauth_providers: [:facebook, :github, :google_oauth2]

  validates :name, presence: true

  has_many :groups, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def self.from_omniauth(auth)
    if @email = auth.info.email
      where(email: @email).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name   # assuming the user model has a name
      end
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = "no@email"
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name   # assuming the user model has a name
      end
    end
  end

end
