class VerbsController < ApplicationController
  # GET /verbs
  # GET /verbs.json

  before_filter :authenticate_user!, :except => [:select_part, :forward_test, :forward_test_step]

  
  def index
    @verbs = Verb.where(:language => @language).order(:verb).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @verbs }
    end
  end

  # GET /verbs/1
  # GET /verbs/1.json
  def show
    @verb = Verb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @verb }
    end
  end

  # GET /verbs/new
  # GET /verbs/new.json
  def new
    @verb = Verb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @verb }
    end
  end

  # GET /verbs/1/edit
  def edit
    @verb = Verb.find(params[:id])
  end

  # POST /verbs
  # POST /verbs.json
  def create
    @verb = Verb.new(params[:verb])
    @verb.language = @language

    respond_to do |format|
      if @verb.save
        format.html { redirect_to controller: :verbs, action: :new, notice: 'Verb was successfully created.' }
        format.json { render json: @verb, status: :created, location: @verb }
      else
        format.html { render action: "new" }
        format.json { render json: @verb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /verbs/1
  # PUT /verbs/1.json
  def update
    @verb = Verb.find(params[:id])

    respond_to do |format|
      if @verb.update_attributes(params[:verb])
        format.html { redirect_to controller: :verbs, action: :index, notice: 'Verb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @verb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /verbs/1
  # DELETE /verbs/1.json
  def destroy
    @verb = Verb.find(params[:id])
    @verb.destroy

    respond_to do |format|
      format.html { redirect_to verbs_url }
      format.json { head :no_content }
    end
  end
  
  def forward_test
    @verbs = Verb.where(:language => @language).where(:part => params[:part_id]).all
    if @verbs.empty?
      redirect_to :controller => :main, :action => :index
    end 
  end

  def forward_test_step
    @verb = Verb.find(params[:id])
    @translations = [[@verb.translation, @verb.clarification]]
    @verbs = [@verb.verb]
    for i in 1..3
        tr2 = @translations.collect{ |t| "'" + t[0] + "'" }.join(",")
        vr = @verbs.collect{ |v| "'" + v + "'" }.join(",")
        off1 = rand(Verb.where(:language => @language).where(:part => @verb.part).where("translation not in (#{tr2})").where("verb not in (#{vr})").count)
        verbr = Verb.where(:language => @language).where(:part => @verb.part).where("translation not in (#{tr2})").where("verb not in (#{vr})").first(:offset => off1)
        if !verbr.nil?
          @translations.push [ verbr.translation, verbr.clarification ]
          @verbs.push verbr.verb
        end
    end
    @prepositions = Verb.where(:language => @language).all.collect{|vrx| vrx.preposition}.uniq
    @prepositions.delete(@verb.preposition)
    @prepositions.shuffle!
    @prepositions = @prepositions.slice(0,2)
    @prepositions.push(@verb.preposition)
    respond_to do |format|
      format.json { render json: {verb: @verb, translations: @translations.shuffle, prepositions: @prepositions.sort} }
    end
  end
  
end
