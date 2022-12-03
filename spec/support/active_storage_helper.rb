# frozen_string_literal: true

module ActiveStorageHelper
  def default_image_params
    # use it as `my_object.image.attach(default_image_params)`
    {
      io: File.open(Rails.root.join('spec/support/images/test.png')),
      filename: 'test.png',
      content_type: 'image/png'
    }
  end
end
