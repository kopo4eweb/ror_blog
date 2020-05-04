class PageController < ApplicationController
    def about
        @hideSubscribeInSidebar = true
    end

    def contact
        @hideSubscribeInSidebar = true
    end
end
