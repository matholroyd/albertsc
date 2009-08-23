module ActiveRecord
  module NamedScope
    class Scope
      def selections
        collect {|m| [m.name, m.id]}
      end
      
      def selections_for_receipts
        collect {|m| ["#{m.name} - last receipt exipres #{m.current_payment_expires_on.to_s}", m.id]}
      end
    end
  end
end
