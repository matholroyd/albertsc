module ActiveRecord
  module NamedScope
    class Scope
      def selections
        collect {|m| [m.name, m.id]}
      end
    end
  end
end
