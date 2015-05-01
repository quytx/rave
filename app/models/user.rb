class User < ActiveRecord::Base
  has_many :events
  has_many :event_participants
  has_many :attended_events, through: :event_participants, source: :event
  has_many :photos
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable

  before_save :ensure_authentication_token

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

end
