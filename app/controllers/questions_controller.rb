# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params.merge(author_id: current_user.id))
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    @question.update(question_params.except(:files))
    question_params[:files]&.each do |file|
      @question.files.attach(file)
    end
  end

  def destroy
    @question.destroy if @question.author == current_user
    redirect_to questions_path, notice: 'Your question successfully deleted'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
