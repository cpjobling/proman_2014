class Name

  include Comparable

  attr_reader :title, :first_name, :other_names, :last_name, :preferred_name

  def initialize(first_name,last_name,title='Mr',other_names='',preferred_name='')
    @first_name, @last_name, @title, @other_names, @preferred_name = 
      first_name, last_name, title, other_names, preferred_name
  end

  def to_s
    [@title,@first_name,@other_names,@last_name].join(' ').squeeze(' ')
  end

  def name
    if @preferred_name.blank?
      @first_name
    else
      @preferred_name
    end
  end

  def full_name
    to_s
  end

  def sortable_name
    "#{@last_name}, #{first_name} #{other_names}".squeeze(' ').strip()
  end

  def sortable_name_and_title
    "#{last_name}, #{title} #{first_name1} #{first_name2} #{first_name3}".squeeze(" ").strip
  end

  def formal_address
    "#{title} #{last_name}".squeeze(" ").strip
  end

  def informal_name
    "#{name} #{last_name}".squeeze(" ").strip
  end

  def sortable_informal_name
     "#{last_name}, #{name}".squeeze(" ").strip
  end

  def sortable_informal_name_and_title
     "#{last_name}, #{title} #{name}".squeeze(" ").strip
  end

  # Converts an object of this instance into a database friendly value.
  def mongoize
    { first_name: @first_name, last_name: @last_name, title: @title, other_names: @other_names, preferred_name: @preferred_name }
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

  class << self
    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      Name.new(object[:first_name], object[:last_name], object[:title], object[:other_names], object[:preferred_name])
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when Name then object.mongoize
      when Hash then Name.new(object[:first_name], object[:last_name], object[:title], 
              object[:other_names], object[:preferred_name]).mongoize
      else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when Name then object.mongoize
      else object
      end
    end
  end
end