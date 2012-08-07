class OldTwitsController < ApplicationController
  # GET /old_twits
  # GET /old_twits.xml
  def index
    @old_twits = OldTwit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @old_twits }
    end
  end

  # GET /old_twits/1
  # GET /old_twits/1.xml
  def show
    @old_twit = OldTwit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @old_twit }
    end
  end

  # GET /old_twits/new
  # GET /old_twits/new.xml
  def new
    @old_twit = OldTwit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @old_twit }
    end
  end

  # GET /old_twits/1/edit
  def edit
    @old_twit = OldTwit.find(params[:id])
  end

  # POST /old_twits
  # POST /old_twits.xml
  def create
    @old_twit = OldTwit.new(params[:old_twit])

    respond_to do |format|
      if @old_twit.save
        format.html { redirect_to(@old_twit, :notice => 'Old twit was successfully created.') }
        format.xml  { render :xml => @old_twit, :status => :created, :location => @old_twit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @old_twit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /old_twits/1
  # PUT /old_twits/1.xml
  def update
    @old_twit = OldTwit.find(params[:id])

    respond_to do |format|
      if @old_twit.update_attributes(params[:old_twit])
        format.html { redirect_to(@old_twit, :notice => 'Old twit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @old_twit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /old_twits/1
  # DELETE /old_twits/1.xml
  def destroy
    @old_twit = OldTwit.find(params[:id])
    @old_twit.destroy

    respond_to do |format|
      format.html { redirect_to(old_twits_url) }
      format.xml  { head :ok }
    end
  end
end
