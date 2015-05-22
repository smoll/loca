module Loca
  module Utils
    # returns false if str is nil, or not a String, or an empty String
    def non_empty_string?(str)
      !str.strip.empty?
    rescue NameError, NoMethodError
      false
    end

    module_function :non_empty_string?
  end
end
