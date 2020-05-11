class Post < ApplicationRecord
  mount_uploader :img, ImageUploader
end
