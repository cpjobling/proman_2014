require "rspec"

describe Name do

  let (:name) { FactoryGirl.build(:name, 
    {first_name: 'John', last_name: 'Tolkien', honorific: 'Prof.', 
    other_names: 'Ronald Reuel', preferred_name: 'JRR'}) }
  let (:john) { FactoryGirl.build(:name, 
    {first_name: 'John', last_name: 'Tolkien', honorific: 'Prof.', 
    other_names: 'Ronald Reuel'}) }

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
      Name.new({first_name: "Bilbo",last_name: "Baggins"}).full_name.should == "Mr Bilbo Baggins"
    end
    it "Should not print missing other names" do
      Name.new({first_name: "Gandalf", last_name: "The White", honorific: "Wiz."}).full_name.should == "Wiz. Gandalf The White"
    end
  end

  describe "#==" do
    it "should return true when objects are equal" do
      (name == Name.new({first_name: 'John', last_name: 'Tolkien', 
        honorific: 'Prof.', other_names: 'Ronald Reuel', preferred_name: 'JRR'})).should be_true
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
      (name.eql? Name.new({first_name: 'John', last_name: 'Tolkien', 
        honorific: 'Prof.', other_names: 'Ronald Reuel', preferred_name: 'JRR'})).should be_true
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
      (Name.new({first_name: "Bilbo", last_name: "Baggins"}) <=> Name.new({first_name: "Bilbo", last_name: "Baggins"})).should == 0
    end
    it "should return -1 when name precedes other name" do
      (Name.new({first_name: "Bilbo", last_name: "Baggins"}) <=> Name.new({first_name: "Frodo", last_name: "Baggins"})).should == -1
    end
    it "should return +1 when name comes after other name" do
      (Name.new({first_name: "Bilbo", last_name: "Baggins"}) <=> Name.new({first_name: "Arthur", last_name: "Baggins"})).should == +1
    end
  end

  it { should validate_presence_of(:honorific) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

end