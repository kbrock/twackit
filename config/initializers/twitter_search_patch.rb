# Patch to fix JSON parse error.
# http://github.com/jnunemaker/twitter/issues#issue/9
module Twitter
  class Search
    def fetch(force=false)
      if @fetch.nil? || force
        query = @query.dup

        query[:q] = query[:q].join(' ')
        query[:format] = 'json' #This line is the hack and whole reason we're monkey-patching at all.

        response = self.class.get('http://search.twitter.com/search', :query => query, :format => :json)

        @fetch = Mash.new(response)
      end

      @fetch
    end 
  end
end