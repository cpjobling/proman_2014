class Name
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

  def mongoize
    { first_name: @first_name, last_name: @last_name, title: @title, other_names: @other_names, preferred_name: @preferred_name }
  end
end