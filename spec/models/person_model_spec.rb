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
	  it "should allow me to find people who live in Colorado"
	end
	describe "filter_results" do
	  it "should allow me to find ‘local’ SE-Tech part time students"
		it "should show me who has a default profile image"
		it "should show me who is going to graduate this year"
	  it "should show me who has an empty CMU-SV email address"
	  it "should show me SE students who do not have a tigris account"
	  it "should allow me to find part time students who have taken MfSE in the Fall of 2010"
	  it "should allow me to filter by ‘active’ or ‘inactive’ users, the default is ‘active’"
	end
end
