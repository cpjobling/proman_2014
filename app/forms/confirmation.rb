class Confirmation
  include Virtus
  
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  attr_reader :honorific
  attr_reader :first_name
  attr_reader :last_name
  attr_reader :other_names
  attr_reader :preferred_name

  delegate :password, :password_confirmation, :email, to: :user

  def user
    @user
  end

  attribute :honorific, String
  attribute :first_name, String
  attribute :last_name, String
  attribute :other_names, String
  attribute :preferred_name, String
  attribute :password_confirmation, String

  validates :honorific, :first_name, :last_name, presence: true

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def submit(params)
    user.attributes = params.slice(:password, :password_confirmation)
    name.attributes = params.slice(:honorific,:first_name,:last_name,:other_names,:preferred_name)

    if user.valid? and valid?
      persist!
      true
    else
      false
    end

  end

  private

    def persist!
      @user.name =  Name.new(first_name,last_name,honorific,other_names,preferred_name)
      @user.save!
    end

end