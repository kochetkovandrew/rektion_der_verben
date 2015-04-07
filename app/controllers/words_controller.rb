class WordsController < ApplicationController
  # GET /words
  # GET /words.json
  def index
    @words = Word.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @words }
    end
  end

  # GET /words/1
  # GET /words/1.json
  def show
    @word = Word.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @word }
    end
  end

  # GET /words/new
  # GET /words/new.json
  def new
    @word = Word.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @word }
    end
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(params[:word])

    respond_to do |format|
      if @word.save
        format.html do
          new_word = @word
          @word = Word.new(
            :topic_id => new_word.topic_id,
            :part => new_word.part
          )
          render action: 'new' 
          # redirect_to @word, notice: 'Word was successfully created.'
        end
        format.json { render json: @word, status: :created, location: @word }
      else
        format.html { render action: "new" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /words/1
  # PUT /words/1.json
  def update
    @word = Word.find(params[:id])

    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :no_content }
    end
  end

  def download
    topic = Topic.find(params[:topic_id])
    filename = topic.level.name + '_' + topic.name + '_' + t(:vocabular).to_s + '.xlsx'
    Rails.logger.debug '-------------'
    Rails.logger.debug filename
    Rails.logger.debug     Rails.root.join('tmp', filename)
    Rails.logger.debug '-------------'
    words = Word.where(:topic_id => params[:topic_id]).order(:speech_part).order(:word).all
    workbook = XLSX::Workbook.new
    worksheet = workbook.create_worksheet :name => t(:vocabular)
    for i in 0..(words.count-1)
      worksheet.update_row(i, words[i].article, words[i].word, t(words[i].speech_part), words[i].translation)
    end
    workbook.write Rails.root.join('tmp', filename)
    send_file Rails.root.join('tmp', filename), :type => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :filename => filename     
    # File.unlink Rails.root.join('tmp', filename)
  end

  def parts
    words = Word.where(:topic_id => params[:topic_id]).group(:part).select('part, count(words.id)').all
    @parts = words.collect{|w| w.part}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parts }
    end
  end

  def forward_test
    Rails.logger.debug params
    @words = Word.where(:topic_id => params[:topic_id]).where(:part => params[:part]).all
    if @words.empty?
      redirect_to :controller => :main, :action => :index
    end
  end

  def forward_test_step
    @word = Word.find(params[:id])
    @translations = [@word.translation]
    @words = [@word.word]
    for i in 1..3
        tr2 = @translations.collect{ |t| "'" + t[0] + "'" }.join(",")
        vr = @words.collect{ |v| "'" + v + "'" }.join(",")
        off1 = rand(Word.where(:part => @word.part).where(:topic_id => @word.topic_id).where(:speech_part => @word.speech_part).where("translation not in (#{tr2})").where("word not in (#{vr})").count)
        wordsr = Word.where(:part => @word.part).where(:topic_id => @word.topic_id).where(:speech_part => @word.speech_part).where("translation not in (#{tr2})").where("word not in (#{vr})").first(:offset => off1)
        if !wordsr.nil?
          @translations.push wordsr.translation
          @words.push wordsr.word
        end
    end
    respond_to do |format|
      format.json { render json: {entity: @word, translations: @translations.shuffle} }
    end
  end

end
