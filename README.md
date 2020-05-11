# README

Implementation a simple blog using a ready-made template

##Gems:

1. `will_paginate`

    1. Add `gem 'will_paginate', '~> 3.1.0'` to Gemfile
    2. Run `bundle install`
    3. Add / replace in a controller `@posts = Post.all` to `@posts = Post.paginate(page: params[:page], per_page: 1)`
    4. Add new helper at folder initialize app `config/aintializers` create a new file `pagination_helper.rb`. Customization hes for himself.
    5. Add output pagination on page `<%= will_paginate @posts, renderer: 'PaginationHelper::LinkRenderer', previous_label: '<', next_label: '>', class: "block-27" %>`
    6. More info on git repo on the [page](https://github.com/mislav/will_paginate)   

2. `carrierwave` - uploader file

    1. Add to GEmfile:
        1. `gem 'carrierwave', '~> 2.0'`
        2. `gem "mini_magick"` - before, install this package on own PC
    2. Run `bundle install`
    3. Generate uploader, run `rails g uploader Image`
    4. Do customization this file for himself:
        1. Enabled `include CarrierWave::MiniMagick`
        2. Add different versions of your uploaded files:
            ```ruby  
                version :large do
                 process resize_to_fit: [800, 1024]
                end
                
                version :medium do
                 process resize_to_fit: [680, 400]
                end
                
                version :thumb do
                 process resize_to_fit: [150, 150]
                end
           ``` 
        3. enabled allowed files:
            ```ruby
                 def extension_whitelist
                    %w(jpg jpeg gif png)
                  end
            ```
    5. Create migration for connection Image and Pots `rails g migration AddImageToPosts image:string`
    6. Run `rake db:migrate`
    7. Add to model Posts `mount_uploader :image, ImageUploader`
    8. Add new / edit form field `<%= f.file_field :img %>`
    9. Output on a page `style="<%= "background-image: url(#{post.img.url(:medium)});" if post.img? %>"` or `<%= image_tag @post.img.url(:thumb) if @post.img? %>`