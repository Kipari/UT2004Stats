require 'ut2004stats/events'
require 'ut2004stats/game'

require 'erb'

module UT2004Stats
  module Output
    class HTML
      def output ( db )
        dir = File.dirname(__FILE__)
        File.open("output/index.html", 'w+') do |f|
          f << ERB.new(File.read "#{dir}/html/index.erb").result
        end
      end
    end
  end
end
      
