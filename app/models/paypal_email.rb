class PaypalEmail < ActiveRecord::Base
  validates_presence_of :source
  
  before_save :set_message_id  
  before_save :set_booleans  
  has_one :receipt
  has_one :member, :through => :receipt
  accepts_nested_attributes_for :receipt, :reject_if => Proc.new { |attrs| attrs['member_id'].blank? && attrs['payment_expires_on'].blank? }
  
  named_scope :processed, :conditions => {:transfered_money_out_of_paypal => true, :recorded_in_accounting_package => true}
  named_scope :not_processed, :conditions => ['(transfered_money_out_of_paypal <> ?) OR (recorded_in_accounting_package <> ?)', true, true]
  
  def tmail
    @tmail ||= TMail::Mail.parse(source)
  end
  
  def name
    tmail.subject
  end

  def self.import_pending
    if ENV['RAILS_ENV'] == 'production'
      DBC.require(GMailSearcher.can_connect?(ENV['PAYPAL_EMAIL_ADDRESS'], ENV['PAYPAL_EMAIL_PASSWORD']), 'bad email login')
      gmail = GMailSearcher.new ENV['PAYPAL_EMAIL_ADDRESS'], ENV['PAYPAL_EMAIL_PASSWORD']
      gmail.process_all do |imap, uid, source| 
        insert_record(source)        
        archive_email(imap, uid)
      end
    end
  end
  
  def guessed_amount_paid
    text = find_text(/received a payment of .* AUD from/)
    text[/\d+\.\d+/]
  end
  
  def guessed_paypal_fee
    begin
      amount = guessed_amount_paid.to_f
      result = amount * 0.024 + 0.3
    rescue 
      result = 0.0
    end
    result.round(2)
  end
  
  def guessed_email
    text = tmail.from.first
  end
  
  def guessed_name
    text = find_text(/Buyer\:.*/)
    text = text.sub(/Buyer\:/, '')
    if text.blank?
      text = find_text(/received a payment of .* AUD from [\w|\s]* \(/)
      text = text.sub(/received a payment of .* AUD from /, '').sub(/ \(/, '')
    end
    text
  end
  
  def guessed_member_id
    result = nil
    unless guessed_email.blank?
      member = Member.find_by_email(guessed_email)
      result = member.id if member
    end
    result
  end
  
  private 
  
  def find_text(pattern)
    if tmail.body =~ pattern 
      $&
    else 
      "" 
    end 
  end
  
  def set_message_id
    self.message_id = tmail.message_id
  end
  
  def set_booleans
    self.transfered_money_out_of_paypal ||= false
    self.recorded_in_accounting_package ||= false
    true
  end
  
  def self.insert_record(source)
    paypal_email = new :source => source
    paypal_email.save!
  end

  def self.archive_email(imap, uid)
    imap.uid_copy(uid, "[Gmail]/All Mail")
    imap.uid_store(uid, "+FLAGS", [:Deleted])
  end
  
end
