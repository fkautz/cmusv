require 'spec_helper'

describe DeliverableSubmissionsController do
  integrate_views
  it "allows a file to be downloaded" do
    get :download, :id => 1
  end
  it "allows a file owned by a team to be opened by any team member"
  it "allows an individual file owner to download his or her own file"
  it "does not allow someone from another team to access their files"
end
