# README

Implementation a simple blog using a ready-made template

## Gems:

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
    
3. `trix-rails` - WYSIWYG Editor
    1. Add to Gemfile `gem 'trix-rails', require: 'trix'`
    2. Run `bundle install`
    3. Add `<%= f.trix_editor :content, class: 'editor' %>` to edit form instead `<%= f.text_area :content, class: 'form-control' %>`
    4. Require JS `//= require trix` and CSS `*= require trix` of Trix to access app
    5. Output `<%= @post.content.html_safe %>`  
    
4. AJAX upload files to Trix Editor
    1. Create model `rails g model Picture image:string`
    2. Run `rake db:migrate`
    3. Add to model Pictures `mount_uploader :image, ImageUploader`
    4. Create controller `rails g controller Pictures`
    5. Add methods at this controller
        ```ruby
         def create
           @picture = Picture.new(image_params)
           @picture.save
           respond_to do |format|
             format.json { render :json => { url: @picture.image.url(:large), picture_id: @picture.id } }
           end
         end
       
         def destroy
           picture = Picture.find(params[:id])
           picture.destroy
           respond_to do |format|
             format.json { render json: { status: :ok} }
           end
         end
       
         private
       
         def image_params
           params.require(:picture).permit(:image)
         end
        ``` 
   6. Add coffee script for ajax
        ```coffeescript
        $ ->
          document.addEventListener 'trix-attachment-add', (event) ->
            attachment = event.attachment
            if attachment.file
              return sendFile(attachment)
            return
        
          document.addEventListener 'trix-attachment-remove', (event) ->
            attachment = event.attachment
            deleteFile attachment
        
          sendFile = (attachment) ->
            token = getToken()
        
            file = attachment.file
            form = new FormData
            form.append 'Content-Type', file.type
            form.append 'picture[image]', file
            xhr = new XMLHttpRequest
            xhr.open 'POST', '/pictures', true
            xhr.setRequestHeader("X-CSRF-Token", token);
        
            xhr.upload.onprogress = (event) ->
              progress = undefined
              progress = event.loaded / event.total * 100
              attachment.setUploadProgress progress
        
            xhr.onload = ->
              response = JSON.parse(@responseText)
              attachment.setAttributes
                url: response.url
                picture_id: response.picture_id
                href: response.url
        
            xhr.send form
        
          deleteFile = (n) ->
            token = getToken()
            $.ajax
              method: 'DELETE'
              url: '/pictures/' + n.attachment.attributes.values.picture_id
              headers: {"X-CSRF-Token": token}
              cache: false
              contentType: false
              processData: false
        
          getToken = () ->
            $('meta[name="csrf-token"]').attr('content')
        
          return
        ```
    7. Add resources in routes file `resources :pictures, only: [:create, :destroy]`