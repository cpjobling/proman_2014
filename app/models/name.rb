class Name

  include Comparable
  include Mongoid::Document

  embedded_in :user

  attr_accessible :honorific, :first_name, :other_names, :last_name, :preferred_name

  field :honorific, type: String, default: 'Mr'
  field :first_name, type: String
  field :other_names, type: String
  field :last_name, type: String
  field :preferred_name, type: String

  validates :honorific, :first_name, :last_name, presence: true

  def to_s
    [honorific,first_name,other_names,last_name].join(' ').squeeze(' ')
  end

  def name
    if preferred_name.blank?
      first_name
    else
      preferred_name
    end
  end

  def full_name
    to_s
  end

  def sortable_name
    "#{last_name}, #{first_name} #{other_names}".squeeze(' ').strip()
  end

  def sortable_name_and_honorific
    "#{last_name}, #{honorific} #{first_name1} #{first_name2} #{first_name3}".squeeze(" ").strip
  end

  def formal_address
    "#{honorific} #{last_name}".squeeze(" ").strip
  end

  def informal_name
    "#{name} #{last_name}".squeeze(" ").strip
  end

  def sortable_informal_name
     "#{last_name}, #{name}".squeeze(" ").strip
  end

  def sortable_informal_name_and_honorific
     "#{last_name}, #{honorific} #{name}".squeeze(" ").strip
  end

  def ==(other)
    return false unless other.class == Name
    self.to_s == other.to_s && self.preferred_name == other.preferred_name
  end

  def hash
    self.to_s.hash
  end

  def eql?(other)
    self == other
  end

  def <=>(other)
    self.sortable_name <=> other.sortable_name
  end

end