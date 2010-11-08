require 'spec_helper'

describe PeopleController do
  integrate_views
  fixtures :users

  describe "search" do
    before(:all) do
      activate_authlogic
    end

    it "should show all people" do
      UserSession.create(users(:faculty_frank))
      people = [Person.find(:first)]
      Person.should_receive(:find).and_return(people)
      get :index
      response.should be_success
      assigns(:people).should == people
    end

    it "should show all people on an empty query" do
      UserSession.create(users(:faculty_frank))
      people = [Person.find(:first)]
      Person.should_receive(:full_search).with("").and_return(people)
      get :index, :search => ""
      response.should be_success
      assigns(:people).should == people
    end

    it "should allow me to find people with a given search string" do
      UserSession.create(users(:faculty_frank))
			people = [users(:faculty_frank)]
			Person.should_receive(:full_search).with("Electronic Arts").and_return(people)
			get :index, :search => "Electronic Arts"
			response.should be_success
    end

    # These belong in the view w/jscript
    it "should allow me to sort by any column" #Note: we don’t expect this to be an automated test
    it "bug fix on javascript: when I return to the search results page, it should both remember and display the state of the last search"
  end

  describe "filter_results" do
    it "should allow me to find ‘local’ SE-Tech part time students" do
      UserSession.create(users(:faculty_frank))
      people = Person.find(:all)
      people[0].local_near_remote = 'Local'
      local_people = people.find_all {|p| p.local_near_remote == 'Local'}
      Person.should_receive(:full_search).with('').and_return(people)
      get :index, :search => '', :proximity => 'Local'
      response.should be_success
      assigns(:people).should == local_people
    end
    it "should show me who has a default profile image" do
      UserSession.create(users(:faculty_frank))
      people = Person.find(:all)
      people[0].image_uri = 'images/mascot.jpg'
      people_with_default_image = people.find_all {|p| p.image_uri == 'images/mascot.jpg'}
      Person.should_receive(:full_search).with('').and_return(people)
      get :index, :search => '', :default_image => 'true'
      response.should be_success
      assigns(:people).should == people_with_default_image
    end
    it "should show me who is going to graduate this year" do
      UserSession.create(users(:faculty_frank))
      people = Person.find(:all)
      people[0].graduation_year = Time.now.year.to_s
      people_graduating_soon = people.find_all {|p| p.graduation_year == Time.now.year.to_s}
      Person.should_receive(:full_search).with('').and_return(people)
      get :index, :search => '', :graduating_soon => 'true'
      response.should be_success
      assigns(:people).should == people_graduating_soon
    end
    it "should show me who has an empty CMU-SV email address" do
      UserSession.create(users(:faculty_frank))
      people = Person.find(:all)
      people = people.slice(0,4)
      people[0].email = '@sv.cmu.edu'
      people[1].email = ''
      people[2].email = nil
      people[3].email = 'student@sv.cmu.edu'
      people_without_email = people.slice(0,3)
      Person.should_receive(:full_search).with('').and_return(people)
      get :index, :search => '', :blank_email => 'true'
      response.should be_success
      assigns(:people).should == people_without_email
    end

    it "should show me SE students who do not have a tigris account" do
      UserSession.create(users(:faculty_frank))
      people = Person.find(:all)
      people = people.slice(0, 3)
      people[0].tigris = nil
      people[1].tigris = ''
      people[2].tigris = 'tigris'
      people_without_tigris1 = people.find_all {|p| p.tigris.nil?}
      people_without_tigris2 = people.find_all {|p| p.tigris == ''}
      people_without_tigris = people_without_tigris1 + people_without_tigris2
      Person.should_receive(:full_search).with('').and_return(people)
      get :index, :search => '', :no_tigris => 'true'
      response.should be_success
      result = assigns(:people) - people_without_tigris
      assigns(:people).should == people_without_tigris
    end

    # TODO: break this into two parts
    it "should allow me to find part time students who have taken MfSE in the Fall of 2010"
    it "should allow me to filter by ‘active’ or ‘inactive’ users, the default is ‘active’"
  end
end

