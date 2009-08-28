class InvoicesController < ApplicationController
  
  def index
    member = Member.find(session[:member_ids].first) || Member.principals.first
    
    
    pdf = PDF::Writer.new
    pdf.select_font "Helvetica"
    pdf.font_size = 20
    pdf.text "Albert Sailing Club Incorporated", :justification => :right
    pdf.text "Yearly Membership Fees", :justification => :right

    pdf.font_size = 12

    pdf.move_pointer 10
    pdf.text [member.title, member.first_name, member.last_name].join(' ')
    pdf.text member.street_address_1
    pdf.text member.street_address_2
    pdf.text member.suburb
    pdf.text [member.state.upcase, member.postcode].join(', ')

    pdf.move_pointer 20
    pdf.text 'Membership and racking fees'
    
    pdf.move_pointer 5

    table = PDF::SimpleTable.new 
    table.position = :right
    table.orientation = :left
    table.column_order = [ "Item", "Quantity", "Fee", "Total" ] 
    table.columns["Item"] = PDF::SimpleTable::Column.new("name") { |col| 
      col.heading = "Item" 
      col.width = 200 
    }

    table.data = []
    table.data << { "Item" => "#{member.membership_type.name} Membership", "Quantity" => 1, 
        "Fee" => member.membership_type.fee, "Total" => member.membership_type.fee }
    member.assets.invoiceable.each do |asset|
      table.data << { "Item" => asset.asset_type.name, "Quantity" => 1, 
        "Fee" => asset.asset_type.invoice_fee, "Total" => asset.asset_type.invoice_fee}
    end
    table.render_on(pdf) 

    pdf.text "Total due", :justification => :right
    
    path = RAILS_ROOT + '\tmp\invoices.pdf'
    pdf.save_as(path)

    send_data(File.read(path), :filename => 'invoices.pdf', 
      :type => 'application/pdf', :disposition => 'inline')
  end
end
