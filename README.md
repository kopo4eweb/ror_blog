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

