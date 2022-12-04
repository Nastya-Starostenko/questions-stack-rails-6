# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy mark_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(author_id: current_user.id))

    flash.now[:notice] = 'Your answer successfully created' if @answer.save
  end

  def update
    @answer.update(answer_params.except(:files))
    answer_params[:files]&.each do |file|
      @answer.files.attach(file)
    end
    @question = @answer.question
  end

  def destroy
    @question = @answer.question

    if @answer.author == current_user
      @answer.destroy
      flash.now[:notice] = 'Your answer successfully deleted'
    end
  end

  def mark_best
    @question = @answer.question

    @answer.best!
  end

  private

  def find_answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
