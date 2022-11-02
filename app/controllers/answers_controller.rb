# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[edit update destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(author_id: current_user.id))

    redirect_to question_path(@question), notice: 'Your answer successfully created' if @answer.save
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy if @answer.author == current_user
    redirect_to question_path(@question), notice: 'Your answer successfully deleted'
  end

  private

  def find_answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
