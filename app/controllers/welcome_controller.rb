class WelcomeController < ApplicationController
  def index
    @user = current_user
    @test_count = @user.max_tests.to_i - TestResult.find_all_by_user_id(@user.id).size
  end

  def test
    @previous_question_set = TestDetail.where(user_id: current_user.id).select(:question_id)
    #render json: @fill_in_the_blank_chapter
    #return
    if !@previous_question_set.blank?
      #@fill_in_the_blank_chapter = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions LEFT OUTER JOIN test_details on test_details.question_id != questions.id where questions.type = 'FillInTheBlank') a where row_number=1;")
      @fill_in_the_blank = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions where questions.type = 'FillInTheBlank' AND questions.id NOT IN (" + @previous_question_set.map { |i| i.question_id }.to_s.gsub('[', '').gsub(']', '') + ")) a where row_number=1;").sample(6)
      #render json: @fill_in_the_blank
      #return
      @fill_in_the_blank_next = Question.where(type: 'FillInTheBlank').where(['id NOT IN (?)', @fill_in_the_blank.map { |q| q.id }]).order('RANDOM()').limit(4).sample(4)

      @true_false = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions where questions.type = 'TrueFalse' AND questions.id NOT IN (" + @previous_question_set.map { |i| i.question_id }.to_s.gsub('[', '').gsub(']', '') + ")) a where row_number=1;").sample(6)
      @true_false_next = Question.where(type: 'TrueFalse').where(['id NOT IN (?)', @true_false.map { |q| q.id }]).order('RANDOM()').limit(4).sample(4)

      @mcq1 = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions where questions.type = 'Mcq1' AND questions.id NOT IN (" + @previous_question_set.map { |i| i.question_id }.to_s.gsub('[', '').gsub(']', '') + ")) a where row_number between 1 AND 3;").sample(18)
      @mcq1_next = Question.where(type: 'Mcq1').where(['id NOT IN (?)', @mcq1.map { |q| q.id }]).order('RANDOM()').limit(2).sample(2)

      @mcq2 = Question.where(type: 'Mcq2').where(['id NOT IN (?)', @previous_question_set.map { |i| i.question_id }]).order('RANDOM()').limit(5)

      @mcq3 = Question.where(type: 'Mcq3').where(['id NOT IN (?)', @previous_question_set.map { |i| i.question_id }]).order('RANDOM()').limit(2)

      @rearrange = Question.where(type: 'Rearrange').where(['id NOT IN (?)', @previous_question_set.map { |i| i.question_id }]).order('RANDOM()').limit(2)

      @short_note_1 = Question.where(type: 'ShortNote', weightage: 2).where(['id NOT IN (?)', @previous_question_set.map { |i| i.question_id }]).order('RANDOM()').limit(2)

      @short_note_2 = Question.where(type: 'ShortNote', weightage: 4).where(['id NOT IN (?)', @previous_question_set.map { |i| i.question_id }]).order('RANDOM()').limit(3)

      @html_code = Question.where(type: 'CodingOutput').where(['id NOT IN (?)', @previous_question_set.map { |i| i.question_id }]).order('RANDOM()').limit(2)
    else
      @fill_in_the_blank = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions where questions.type = 'FillInTheBlank') a where row_number=1;").sample(6)
      @fill_in_the_blank_next = Question.where(type: 'FillInTheBlank').where(['id NOT IN (?)', @fill_in_the_blank.map { |q| q.id }]).order('RANDOM()').limit(4).sample(4)

      @true_false = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions where questions.type = 'TrueFalse') a where row_number=1;").sample(6)
      @true_false_next = Question.where(type: 'TrueFalse').where(['id NOT IN (?)', @true_false.map { |q| q.id }]).order('RANDOM()').limit(4).sample(4)

      @mcq1 = Question.find_by_sql("select * from (SELECT *, row_number() over (partition by chapter_id order by random()) FROM questions where questions.type = 'Mcq1') a where row_number between 1 AND 3;").sample(18)
      @mcq1_next = Question.where(type: 'Mcq1').where(['id NOT IN (?)', @mcq1.map { |q| q.id }]).order('RANDOM()').limit(2).sample(2)

      @mcq2 = Question.where(type: 'Mcq2').order('RANDOM()').limit(5)

      @mcq3 = Question.where(type: 'Mcq3').order('RANDOM()').limit(2)

      @rearrange = Question.where(type: 'Rearrange').order('RANDOM()').limit(2)

      @short_note_1 = Question.where(type: 'ShortNote', weightage: 2).order('RANDOM()').limit(2)

      @short_note_2 = Question.where(type: 'ShortNote', weightage: 4).order('RANDOM()').limit(3)

      @html_code = Question.where(type: 'CodingOutput').order('RANDOM()').limit(2)
    end

    #insert_string = SetObj.insert_obj(@fill_in_the_blank, current_user.id)
    #insert_string << SetObj.insert_obj(@fill_in_the_blank_next, current_user.id)
    #insert_string << SetObj.insert_obj(@true_false, current_user.id)
    #insert_string << SetObj.insert_obj(@true_false_next, current_user.id)
    #insert_string << SetObj.insert_obj(@mcq1, current_user.id)
    #insert_string << SetObj.insert_obj(@mcq1_next, current_user.id)
    #insert_string << SetObj.insert_obj(@mcq2, current_user.id)
    #insert_string << SetObj.insert_obj(@mcq3, current_user.id)
    #insert_string << SetObj.insert_obj(@rearrange, current_user.id)
    #insert_string << SetObj.insert_obj(@short_note_1, current_user.id)
    #insert_string << SetObj.insert_obj(@short_note_2, current_user.id)
    #insert_string << SetObj.insert_obj(@html_code, current_user.id)
    #
    #final_string = insert_string.to_s.gsub('[', '').gsub(']', '').gsub(', ,', '').gsub(' ,', '').gsub('} ', '}')#.split(', ')
    #final_string = '[' + final_string + ']'
    #render json: final_string.to_json
    #return
    #@test = TestResult.create(user_id: current_user.id)
    #@test.test_details << final_string

  end

  def import_questions
    render layout: false
  end

  def create_guest
    email = "#{Time.now.to_i}#{rand(99)}@guestuser.com"
    password = 'ittest_password'
    @user = User.create(email: email, password: password, password_confirmation: password, name: 'Guest', is_guest: true)
    @user.save
    sign_in(:user, @user)
    redirect_to '/admin'
  end

  #def progress_report
  #  @user_test_ids = TestResult.select('id').where(user_id: current_user.id)
  #
  #  @questionwise_score = TestDetail.where(['test_result_id in (?)', @user_test_ids.map{|test| test.id}]).group(:question_type, :test_result_id).sum(:score)
  #
  #  render json: @questionwise_score
  #  return
  #
  #  @final_hash = []
  #
  #  @fill_score = []
  #  @tf_score = []
  #  @mcq1_score = []
  #  @mcq2_score = []
  #  @mcq3_score = []
  #  @rearrange_score =[]
  #
  #  #@final_hash = @final_hash.push(@user_test_ids.map{|test| {test.id => ''}}).first.first
  #  #@final_hash.push({'a' => 1})
  #  @questionwise_score.each do |qscore|
  #    #@user_test_ids.each do |test|
  #        @final_hash.push(qscore[0][1] => [qscore[0][0], qscore[1]])
  #    #end
  #    #case qscore[0][0]
  #    #  when 'FillInTheBlank'
  #    #    @fill_score.push(qscore[0][1] => qscore[1])
  #    #  when 'TrueFalse'
  #    #    @tf_score.push(qscore[0][1] => qscore[1])
  #    #  when 'Mcq1'
  #    #    @mcq1_score.push(qscore[0][1] => qscore[1])
  #    #  when 'Mcq2'
  #    #    @mcq2_score.push(qscore[0][1] => qscore[1])
  #    #  when 'Mcq3'
  #    #    @mcq3_score.push(qscore[0][1] => qscore[1])
  #    #  when 'Rearrange'
  #    #    @rearrange_score.push(qscore[0][1] => qscore[1])
  #    #end
  #  end
  #
  #  #@final_hash.push(@fill_score, @tf_score, @mcq1_score, @mcq2_score, @mcq3_score, @rearrange_score)
  #
  #  #puts '===== >> each element ' + @final_hash[0].first.to_s
  #  #puts '===== >> test id ' + @final_hash[0].first[0].to_s
  #  #puts '===== >> q type ' + @final_hash[0].first[1][0].to_s
  #  #puts '===== >> score ' + @final_hash[0].first[1][1].to_s
  #  #render json: @final_hash[0].first[1]
  #  #return
  #
  #end

end
