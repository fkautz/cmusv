require 'spec_helper'

describe Person do
  describe "full_search" do
    Factory.define :person, :class => Person do |p|
      p.first_name 'person1'
      p.last_name 'person2'
      p.email 'person@sv.cmu.edu'
      p.organization_name 'None'
    end
    Factory.define :organization, :class => Person do |p|
      p.first_name 'organization1'
      p.last_name 'organization2'
      p.email 'organization@sv.cmu.edu'
      p.organization_name 'Organization'
    end
    Factory.define :name, :class => Person do |p|
      p.first_name 'Maon'
      p.last_name 'Kiltweave'
      p.email 'name@sv.cmu.edu'
      p.organization_name 'None'
    end
    Factory.define :location, :class => Person do |p|
      p.first_name 'Loki'
      p.last_name 'Sigyn'
      p.email 'loki@sv.cmu.edu'
      p.organization_name 'Norse Gods'
      p.work_city 'Paris'
      p.work_state 'Texas'
      p.work_country 'United States'
    end
    it "should return all people on a null or empty query" do
      Factory(:person)
      people = Person.full_search(nil)
      original_size = people.size
      
      Factory(:organization)
      people2 = Person.full_search("")
      assert people2.size == (original_size+1), "Full search isn't returning everyone"
    end
    it "should allow me to find people who work for 'Organization'" do
      Factory(:person)
      people = Person.full_search('Organization')
      assert_equal true, people.nil?, "No person should be returned in the org yet"
      person = Factory(:organization)
      people2 = Person.full_search('Organization')
      assert_equal person.organization_name, people2[0].organization_name, "Search for organization is broken"
    end
    it "should allow me to find people based on their name" do
      Factory(:person)

      # assert first name returns nothing
      first_name_empty = Person.full_search('Maon')
      assert_nil first_name_empty

      # assert last name returns nothing
      last_name_empty = Person.full_search('Kiltweave')
      assert_nil last_name_empty

      Factory(:name)
      
      # assert first name returns something
      first_name_populated = Person.full_search('Maon')
      assert_equal 'Maon', first_name_populated[0].first_name, 'Search by first name is broken'

      # assert last name returns something
      last_name_populated = Person.full_search('Kiltweave')
      assert_equal 'Kiltweave', first_name_populated[0].last_name, 'Search by first name is broken'
    end
    it "should allow me to find people who live in Colorado" do
      Factory(:person)
      # city empty
      city_empty = Person.full_search('Paris')
      assert_nil city_empty

      state_empty = Person.full_search('Texas')
      assert_nil state_empty

      country_empty = Person.full_search('United States')
      assert_nil country_empty

      person = Factory(:location)
      city_populated = Person.full_search('Paris')
      assert_equal person.work_city, city_populated[0].work_city, "Search by city is broken"

      state_populated = Person.full_search('Texas')
      assert_equal person.work_state, state_populated[0].work_state, "Search by city is broken"

      country_populated = Person.full_search('United States')
      assert_equal person.work_country, country_populated[0].work_country, "Search by city is broken"
    end
  end
end
