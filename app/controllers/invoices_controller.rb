class InvoicesController < ApplicationController
  include RTF
  
  def index
    fonts = [Font.new(Font::ROMAN, 'Times New Roman'),
             Font.new(Font::MODERN, 'Courier')]

    styles = {}
    styles['PS_HEADING']              = ParagraphStyle.new
    styles['PS_NORMAL']               = ParagraphStyle.new
    styles['PS_NORMAL'].justification = ParagraphStyle::FULL_JUSTIFY
    styles['PS_INDENTED']             = ParagraphStyle.new
    styles['PS_INDENTED'].left_indent = 300
    styles['PS_TITLE']                = ParagraphStyle.new
    styles['PS_TITLE'].space_before   = 100
    styles['PS_TITLE'].space_after    = 200
    styles['CS_HEADING']              = CharacterStyle.new
    styles['CS_HEADING'].bold         = true
    styles['CS_HEADING'].font_size    = 36
    styles['CS_CODE']                 = CharacterStyle.new
    styles['CS_CODE'].font            = fonts[1]
    styles['CS_CODE'].font_size       = 16
    styles['EMPHASISED']             = CharacterStyle.new
    styles['EMPHASISED'].bold        = true
    styles['EMPHASISED'].underline   = true

    document = Document.new(Font.new(Font::ROMAN, 'Arial'))

    document.paragraph(styles['PS_NORMAL']) do |p|
       p << 'This document is a simple programmatically generated file that is '
       p << 'used to demonstrate table generation. A table containing 3 rows '
       p << 'and three columns should be displayed below this text.'
    end

    table    = document.table(3, 3, 2000, 4000, 2000)
    table.border_width = 5
    table[0][0] << 'Cell 0,0'
    table[0][1].top_border_width = 10
    table[0][1] << 'This is a little preamble text for '
    table[0][1].apply(styles['EMPHASISED']) << 'Cell 0,1'
    table[0][1].line_break
    table[0][1] << ' to help in examining how formatting is working.'
    table[0][2] << 'Cell 0,2'
    table[1][0] << 'Cell 1,0'
    table[1][1] << 'Cell 1,1'
    table[1][2] << 'Cell 1,2'
    table[2][0] << 'Cell 2,0'
    table[2][1] << 'Cell 2,1'
    table[2][2] << 'Cell 2,2'

    send_data(document.to_rtf, :filename => 'invoices.rtf', 
      :type => 'text/rtf', :disposition => 'inline')
  end
end
