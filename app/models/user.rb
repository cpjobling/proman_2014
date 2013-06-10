class User
  include Mongoid::Document
  rolify
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@(swan|swansea)\.ac\.uk\z/i, 
    message: "You can only request an invitation if you have valid #{ENV['INSTITUTION']} email account.."}

  # override Devise method
  # no password is required when the account is created; validate password when the user sets one
  validates_confirmation_of :password
  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  # override Devise method
  def confirmation_required?
    false
  end

  # override Devise method
  def active_for_authentication?
    confirmed? || confirmation_period_valid?
  end

  def send_reset_password_instructions
    if self.confirmed?
      super
    else
      errors.add :base, "You must receive an invitation before you set your password."
    end
  end

  delegate :first_name, :last_name, :honorific, :other_names, :preferred_name, to: :name
  
  ## MongoDB Fields

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Name
  field :name, :type => Name, :default => Name.new('Anne','Onymous','Ms')

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  #validates_presence_of :name
  attr_accessible :role_ids, :as => :admin
  attr_accessible :honorific, :first_name, :last_name, :other_names, :preferred_name
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  before_save :initialize_name
  after_create :add_user_to_mailchimp
  before_destroy :remove_user_from_mailchimp

  # new function to set the password
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to determine whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method pending_any_confirmation
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

private

  def initialize_name
    name = Name.new(first_name,last_name,honorific,other_names,preferred_name)
  end

  def add_user_to_mailchimp
      return if email.include?(ENV['ADMIN_EMAIL'])
      mailchimp = Gibbon.new
      result = mailchimp.list_subscribe({
        :id => ENV['MAILCHIMP_LIST_ID'],
        :email_address => self.email,
        :double_optin => false,
        :update_existing => true,
        :send_welcome => true
        })
      Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
    rescue Gibbon::MailChimpError => e
      Rails.logger.info("MailChimp subscribe failed for #{self.email}: " + e.message)
    end

  def remove_user_from_mailchimp
    mailchimp = Gibbon.new
    result = mailchimp.list_unsubscribe({
      :id => ENV['MAILCHIMP_LIST_ID'],
      :email_address => self.email,
      :delete_member => true,
      :send_goodbye => false,
      :send_notify => true
      })
    Rails.logger.info("Unsubscribed #{self.email} from MailChimp") if result
  rescue Gibbon::MailChimpError => e
    Rails.logger.info("MailChimp unsubscribe failed for #{self.email}: " + e.message)
  end


end
