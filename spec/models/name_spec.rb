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

  describe "#sortable_name_and_title" do
    it "prints sortable name" do
      name.sortable_name.should eql "Tolkien, John Ronald Reuel"
    end
  end

  describe "#formal_address" do
    it "prints title and surname" do
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

  describe "#sortable_informal_name_and_title" do
    it "prints first name, title and surname" do
      john.sortable_informal_name_and_title.should eql "Tolkien, Prof. John"
    end

    it "prints preferred name, title and surname" do
      name.sortable_informal_name_and_title.should eql "Tolkien, Prof. JRR"
    end
  end

  describe "Corner cases" do
    pending
  end

  describe "#mongoize" do
    it "should return a hash" do
      expected = { first_name: name.first_name, last_name: name.last_name, title: name.title, other_names: name.other_names, preferred_name: name.preferred_name }
      name.mongoize.should be_eql expected
    end
  end

  describe "Name.demongoize" do
    pending
  end

  describe "Name.mongoize" do
    pending
  end

  describe "Name.evolve" do
    pending
  end


end