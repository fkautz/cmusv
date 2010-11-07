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
end

