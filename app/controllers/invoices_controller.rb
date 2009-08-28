class InvoicesController < ApplicationController
  
  def index
    member = Member.find(session[:member_ids].first) || Member.principals.first
    
    
    pdf = PDF::Writer.new
    pdf.select_font "Helvetica"
    pdf.font_size = 20
    pdf.text "Albert Sailing Club Incorporated", :justification => :right
    pdf.text "Yearly Membership Fees", :justification => :right

    pdf.font_size = 10

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
    table.shade_rows = :none 
    table.font_size = 10
    table.column_order = [ "Item", "Quantity", "Fee", "Required", "Total" ] 
    table.columns["Item"] = PDF::SimpleTable::Column.new("name") { |col| 
      col.heading = "Item" 
      col.width = 280 
    }
    table.columns["Quantity"] = PDF::SimpleTable::Column.new("row") { |col| 
      col.heading = "Quantity" 
      col.justification = :right
      col.width = 80
    }
    table.columns["Fee"] = PDF::SimpleTable::Column.new("row") { |col| 
      col.heading = "Fee" 
      col.justification = :right 
      col.width = 60
    }
    table.columns["Required"] = PDF::SimpleTable::Column.new("row") { |col| 
      col.heading = "Required" 
      col.justification = :center 
      col.width = 60
    }
    table.columns["Total"] = PDF::SimpleTable::Column.new("row") { |col| 
      col.heading = "Total" 
      col.justification = :right 
      col.width = 60
    }

    table.data = []
    table.data << { "Item" => "#{member.membership_type.name} Membership", "Quantity" => 1, 
        "Fee" => member.membership_type.fee, "Required" => 'Yes', "Total" => member.membership_type.fee }
    member.assets.invoiceable.each do |asset|
      table.data << { "Item" => asset.asset_type.name, "Quantity" => 1, 
        "Fee" => asset.asset_type.invoice_fee, "Required" => 'Yes', "Total" => asset.asset_type.invoice_fee}
    end
    table.render_on(pdf) 
    pdf.text "<b>Total due: #{member.invoice_fee}.00</b>", :justification => :right, :font_size => 12, :right => 5
    
    pdf.move_pointer 20
    pdf.font_size = 10
    pdf.text 'Please check & update the following information:'
    pdf.move_pointer 5
    

    table = PDF::SimpleTable.new 
    table.shade_rows = :none 
    table.show_headings = false 
    table.show_lines = :all
    table.position = :left
    table.orientation = :right
    table.font_size = 9
    
    table.column_order = [ "Item", "Value" ] 
    table.columns["Item"] = PDF::SimpleTable::Column.new("name") { |col| 
      col.heading = "Item" 
      col.width = 120 
    }
    table.columns["Value"] = PDF::SimpleTable::Column.new("name") { |col| 
      col.heading = "Value" 
      col.width = 300 
    }

    table.data = []
    table.data << {"Item" => "Email Address", "Value" => member.email}
    table.data << {"Item" => "Powerboat Licence", "Value" => member.powerboat_licence.to_s}
    table.data << {"Item" => "Occupation", "Value" => member.occupation}
    table.data << {"Item" => "Special skills", "Value" => member.special_skills}
    table.data << {"Item" => "Sex", "Value" => member.sex}
    table.data << {"Item" => "Spouse Name", "Value" => member.spouse_name}
    table.data << {"Item" => "Home Phone", "Value" => member.phone_home}
    table.data << {"Item" => "Work Phone", "Value" => member.phone_work}
    table.data << {"Item" => "Mobile Phone", "Value" => member.phone_mobile}
    table.data << {"Item" => "Registered Boat", "Value" => member}
    table.render_on(pdf) 

    pdf.move_pointer 20
    pdf.font_size = 10
    pdf.text "<b>How to pay</b>"
    pdf.font_size = 9

    pdf.move_pointer 5
    pdf.text '<b>Online:</b> Visit <c:alink uri="http://albertsc.org.au">http://albertsc.org.au</c:alink> and then click <b>Pay fees online</b> in the left side-menu.'

    pdf.move_pointer 5
    pdf.text '<b>Cheque:</b> Return this form with cheque payable to Albert Sailing Club Inc, 1 Aquatic Drive, South Melbourne, VIC, 3205.'

    pdf.move_pointer 5
    pdf.text '<b>Credit Card:</b> Fillout your credit card details and return this form to 1 Aquatic Drive, South Melbourne, VIC, 3205.'

    pdf.move_pointer 20
    pdf.font_size = 10
    pdf.text "Authorization for Credit Card Payment", :justification => :center
    pdf.text "Name on Credit Card:__________________________________________", :spacing => 2
    pdf.text "I authorize Albert Sailing Club Inc to charge my card for $:_____________", :spacing => 2
    pdf.text "Card Number:__________-__________-__________-__________", :spacing => 2
    pdf.text "Expiry Date:________/________", :spacing => 2
    pdf.text "Cardholder signature:_____________________________________", :spacing => 3
    
    
    # table = PDF::SimpleTable.new 
    # table.shade_rows = :none 
    # table.show_headings = false 
    # table.show_lines = :all
    # table.position = :left
    # table.orientation = :right
    # table.font_size = 9
    # 
    # table.column_order = [ "Item", "Value" ] 
    # table.columns["Item"] = PDF::SimpleTable::Column.new("name") { |col| 
    #   col.heading = "Item" 
    #   col.width = 120 
    # }
    # table.columns["Value"] = PDF::SimpleTable::Column.new("name") { |col| 
    #   col.heading = "Value" 
    #   col.width = 300 
    # }
    # 
    # table.data = []
    # table.data << {"Item" => "Email Address", "Value" => member.email}
    # table.data << {"Item" => "Powerboat Licence", "Value" => member.powerboat_licence.to_s}
    # table.data << {"Item" => "Occupation", "Value" => member.occupation}
    # table.data << {"Item" => "Special skills", "Value" => member.special_skills}
    # table.data << {"Item" => "Sex", "Value" => member.sex}
    # table.data << {"Item" => "Spouse Name", "Value" => member.spouse_name}
    # table.data << {"Item" => "Home Phone", "Value" => member.phone_home}
    # table.data << {"Item" => "Work Phone", "Value" => member.phone_work}
    # table.data << {"Item" => "Mobile Phone", "Value" => member.phone_mobile}
    # table.data << {"Item" => "Registered Boat", "Value" => member}
    # table.render_on(pdf)
    
    
    path = RAILS_ROOT + '\tmp\invoices.pdf'
    pdf.save_as(path)

    send_data(File.read(path), :filename => 'invoices.pdf', 
      :type => 'application/pdf', :disposition => 'inline')
  end
  
end
