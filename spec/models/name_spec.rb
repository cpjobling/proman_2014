require "rspec"

describe Name do

  let (:name) { Name.new('John', 'Tolkien', 'Prof.', 'Ronald Reuel', 'JRR') }
  let (:john) { Name.new('John', 'Tolkien', 'Prof.', 'Ronald Reuel') }

  it "prints name in full" do
    name.to_s.should eql "Prof. John Ronald Reuel Tolkien"
  end

  describe "#name" do

    it "prints first forename" do
      john.name.should eql('John')
    end

    it "prints preferred name" do
      name.name.should eql "JRR"
    end
  end

  describe "#full_name" do
    it "prints full name" do
      name.full_name.should eql "Prof. John Ronald Reuel Tolkien"
    end
  end

  describe "#sortable_name" do
    it "prints sortable name" do
      name.sortable_name.should eql "Tolkien, John Ronald Reuel"
    end
  end

  describe "#sortable_name_and_honorific" do
    it "prints sortable name" do
      name.sortable_name.should eql "Tolkien, John Ronald Reuel"
    end
  end

  describe "#formal_address" do
    it "prints honorific and surname" do
      name.formal_address.should eql "Prof. Tolkien"
    end
  end

  describe "#informal_name" do
    it "prints first name and surname" do
      john.informal_name.should eql "John Tolkien"
    end

    it "prints preferred name and surname" do
      name.informal_name.should eql "JRR Tolkien"
    end
  end

  describe "#sortable_informal_name" do
    it "prints first name and surname" do
      john.sortable_informal_name.should eql "Tolkien, John"
    end

    it "prints preferred name and surname" do
      name.sortable_informal_name.should eql "Tolkien, JRR"
    end
  end

  describe "#sortable_informal_name_and_honorific" do
    it "prints first name, honorific and surname" do
      john.sortable_informal_name_and_honorific.should eql "Tolkien, Prof. John"
    end

    it "prints preferred name, honorific and surname" do
      name.sortable_informal_name_and_honorific.should eql "Tolkien, Prof. JRR"
    end
  end

  describe "Corner cases" do
    it "Should have honorific 'Mr' by default" do
      Name.new("Bilbo","Baggins").full_name.should == "Mr Bilbo Baggins"
    end
    it "Should not print missing other names" do
      Name.new("Gandalf","The White","Wiz.").full_name.should == "Wiz. Gandalf The White"
    end
  end

  describe "#mongoize" do
    it "should return a hash" do
      expected = { first_name: name.first_name, last_name: name.last_name, 
        honorific: name.honorific, other_names: name.other_names, 
        preferred_name: name.preferred_name }
      name.mongoize.should be_eql expected
    end
  end

  describe "Name.demongoize" do
    it "should return a Name from a Hash" do
      db_value = name.mongoize
      object = Name.demongoize(db_value)
      object.should be_eql name
    end
  end

  describe "Name.mongoize" do
    it "should return a the mongoized Hash for a Name" do
      expected = { first_name: name.first_name, last_name: name.last_name, honorific: name.honorific, other_names: name.other_names, preferred_name: name.preferred_name }
      puts Name.mongoize(name)
      Name.mongoize(name).should be_eql expected
    end
    it "should instantiate a Name from a Hash then return the mongoized Hash" do
      h = { first_name: name.first_name, last_name: name.last_name, honorific: name.honorific, other_names: name.other_names, preferred_name: name.preferred_name }
      Name.mongoize(h).should be_eql h
    end
    it "should return the parameter if not passed a Name or a Hash" do
      p = name.to_s
      Name.mongoize(p).should be_eql p
    end
  end

  describe "Name.evolve" do
    it "should mongoize a Name when passed a Name" do
      Name.evolve(name).should be_eql name.mongoize
    end
    it "should return the parameter when not passed a Name" do
      Name.evolve(name.to_s).should be_eql name.to_s
    end
  end

  describe "#==" do
    it "should return true when objects are equal" do
      (name == Name.new('John', 'Tolkien', 'Prof.', 'Ronald Reuel', 'JRR')).should be_true
    end
    it "should return false when names are not equal" do
      (name == john).should be_false
    end
    it "name == other should return false when other is not a Name" do
      (name == name.to_s).should be_false
    end
  end

  describe "#hash" do
    it "should equal name.to_s.hash" do
      name.hash.should eql name.to_s.hash
    end
  end

  describe "#eql?" do
    it "should return true when objects are equal" do
      (name.eql? Name.new('John', 'Tolkien', 'Prof.', 'Ronald Reuel', 'JRR')).should be_true
    end
    it "should return false when names are not equal" do
      (name.eql? john).should be_false
    end
    it "name == other should return false when other is not a Name" do
      (name.eql? name.to_s).should be_false
    end
  end

  describe "<=>" do
    it "should return 0 when names are equal" do
      (Name.new("Bilbo", "Baggins") <=> Name.new("Bilbo", "Baggins")).should == 0
    end
    it "should return -1 when name precedes other name" do
      (Name.new("Bilbo", "Baggins") <=> Name.new("Frodo", "Baggins")).should == -1
    end
    it "should return +1 when name comes after other name" do
      (Name.new("Bilbo", "Baggins") <=> Name.new("Arthur", "Baggins")).should == +1
    end
  end

end