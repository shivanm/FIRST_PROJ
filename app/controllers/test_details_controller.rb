class TestDetailsController < ApplicationController
  # GET /test_details
  # GET /test_details.json
  def index
    @test_details = TestDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_details }
    end
  end

  # GET /test_details/1
  # GET /test_details/1.json
  def show
    @test_detail = TestDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @test_detail }
    end
  end

  # GET /test_details/new
  # GET /test_details/new.json
  def new
    @test_detail = TestDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_detail }
    end
  end

  # GET /test_details/1/edit
  def edit
    @test_detail = TestDetail.find(params[:id])
  end

  # POST /test_details
  # POST /test_details.json
  def create
    render json: params
    return

    @test_detail = TestDetail.new(params[:test_detail])

    respond_to do |format|
      if @test_detail.save
        format.html { redirect_to @test_detail, notice: 'Test detail was successfully created.' }
        format.json { render json: @test_detail, status: :created, location: @test_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @test_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /test_details/1
  # PUT /test_details/1.json
  def update
    @test_detail = TestDetail.find(params[:id])

    respond_to do |format|
      if @test_detail.update_attributes(params[:test_detail])
        format.html { redirect_to @test_detail, notice: 'Test detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_details/1
  # DELETE /test_details/1.json
  def destroy
    @test_detail = TestDetail.find(params[:id])
    @test_detail.destroy

    respond_to do |format|
      format.html { redirect_to test_details_url }
      format.json { head :no_content }
    end
  end

  # Used for checking the test being submitted by user.
  def test_submit
    received_params = params
    received_params.delete(:authenticity_token)
    received_params.delete(:controller)
    received_params.delete(:action)

    render json: received_params
    return

    @question = []
    ans = []
    @test = TestResult.create(user_id: current_user.id)

    received_params.each do |param|
      if(param[0].include?('_'))
        @question << Question.find (param[0].split('_')[0].to_i)
      else
        @question << Question.find (param[0].to_i)
      end

      if (@question.type == 'FillInTheBlank' || @question.type == 'Rearrange')
        (@question.options.first.key.casecmp(ans) == 0)? score = 1: score = 0
        @test.test_details << {question_id: @question.id, answer: ans, user_id: current_user.id, score: score}
      elsif (@question.type == 'TrueFalse' || @question.type == 'Mcq1')
        if (ans.include?('_'))
          @test.test_details << {question_id: @question.id, answer: ans.split('_')[0], user_id: current_user.id, score: ans.split('_')[1]}
        elsif (ans != 'None')
          @test.test_details << {question_id: @question.id, answer: ans, user_id: current_user.id, score: @question.options.find_by_key(ans).val}
        else
          @test.test_details << {question_id: @question.id, answer: 'Not Attempted', user_id: current_user.id, score: 0}
        end
      end
    end
  end

end
