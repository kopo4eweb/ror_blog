class PageController < ApplicationController
    def index
    end

    def about
        @hideSubscribeInSidebar = true
        end

    def contact
        @hideSubscribeInSidebar = true
    end
end
