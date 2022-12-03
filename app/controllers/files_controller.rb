# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  def destroy
    @file = ActiveStorage::Attachment.find_by(id: params[:id])
    @file.purge
    flash.now[:notice] = 'Your attachment was successfully deleted'
  end
end
