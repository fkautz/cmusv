class DeliverableSubmissionsController < ApplicationController
  before_filter :require_user, :except => [:show_by_twiki]

  layout 'cmu_sv'

  # GET /deliverable_submissions
  # GET /deliverable_submissions.xml
  def index
    @deliverable_submissions = DeliverableSubmission.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deliverable_submissions }
    end
  end

  # GET /deliverable_submissions/1
  # GET /deliverable_submissions/1.xml
  def show
    @deliverable_submission = DeliverableSubmission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deliverable_submission }
    end
  end

  def download
    download = DeliverableSubmission.find(params[:id])
    if is_allowed(current_user.id, download.id)
      send_file "deliverable_submissions/#{download.id}/#{download.deliverable_file_name}", :type => download.deliverable_content_type
    else
      redirect_to :controller => :deliverable_submissions, :view => :index
    end
  end

  def is_allowed(a, b)
    #TODO fkautz or nvibhor - determine if we are allowed to download this submission
  end

  # GET /deliverable_submissions/new
  # GET /deliverable_submissions/new.xml
  def new
    @deliverable_submission = DeliverableSubmission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deliverable_submission }
    end
  end

  # GET /deliverable_submissions/1/edit
  def edit
    @deliverable_submission = DeliverableSubmission.find(params[:id])
  end

  # POST /deliverable_submissions
  # POST /deliverable_submissions.xml
  def create
    @deliverable_submission = DeliverableSubmission.new(params[:deliverable_submission])
    @deliverable_submission.submission_date = DateTime.now
    @deliverable_submission.person_id = current_user.id

    respond_to do |format|
      if @deliverable_submission.save
        flash[:notice] = 'DeliverableSubmission was successfully created.'
        format.html { redirect_to(@deliverable_submission) }
        format.xml  { render :xml => @deliverable_submission, :status => :created, :location => @deliverable_submission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deliverable_submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deliverable_submissions/1
  # PUT /deliverable_submissions/1.xml
  def update
    @deliverable_submission = DeliverableSubmission.find(params[:id])
    @deliverable_submission.submission_date = DateTime.now

    respond_to do |format|
      if @deliverable_submission.update_attributes(params[:deliverable_submission])
        flash[:notice] = 'DeliverableSubmission was successfully updated.'
        format.html { redirect_to(@deliverable_submission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deliverable_submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deliverable_submissions/1
  # DELETE /deliverable_submissions/1.xml
  def destroy
    @deliverable_submission = DeliverableSubmission.find(params[:id])
    @deliverable_submission.destroy

    respond_to do |format|
      format.html { redirect_to(deliverable_submissions_url) }
      format.xml  { head :ok }
    end
  end
end
