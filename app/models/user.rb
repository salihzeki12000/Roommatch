class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  acts_as_messageable

  # has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  # has_many :received_messages, class_name: 'Message', foreign_key: :recipient_id

  validates_uniqueness_of :email, unless: :uid?
  # validates_presence_of :name

  # has_secure_password

  # add Koala to email?

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #user.email = auth.info.email
    user.email = auth.uid + "@facebook.com"
    user.password = Devise.friendly_token[0,20]
    user.first_name = auth.info.name.split(' ')[0]
    user.last_name = auth.info.name.split(' ')[-1]
    user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def mailboxer_email(object)
    #Check if an email should be sent for that object
      #if true
        return email
      #if false
        #return nil
  end

end
