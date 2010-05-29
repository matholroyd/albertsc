module ActiveRecord
  module NamedScope
    class Scope
      def selections
        collect {|m| [m.name, m.id]}
      end
      
      def selections_for_receipts
        collect {|m| ["#{m.name} - last receipt exipres #{m.current_payment_expires_on.to_s}", m.id]}
      end
      
      def receipt_selections
        collect do |m| 
          receipt = m.last_receipt 
          receipt_id = receipt ? receipt.id : ''
          ["#{m.name} - last receipt exipres #{m.current_payment_expires_on.to_s}", receipt_id]
        end
      end
    end
  end
end
