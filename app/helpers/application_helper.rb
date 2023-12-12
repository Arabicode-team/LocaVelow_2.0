module ApplicationHelper
    def canonical_url
      request.original_url
    end
  end
