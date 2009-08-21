class PaypalEmail < ActiveRecord::Base
  validates_presence_of :source
  
  before_save :set_message_id  
  belongs_to :member
  
  named_scope :processed, :conditions => {:transfered_money_out_of_paypal => true, :recorded_in_accounting_package => true}
  named_scope :not_processed, :conditions => ['NOT ((transfered_money_out_of_paypal == ?) AND (recorded_in_accounting_package == ?))', true, true]
  
  def tmail
    @tmail ||= TMail::Mail.parse(source)
  end
  
  def name
    tmail.subject
  end

  def self.import_pending
    DBC.require(GMailSearcher.can_connect?(ENV['PAYPAL_EMAIL_ADDRESS'], ENV['PAYPAL_EMAIL_PASSWORD']), 'bad email login')
    gmail = GMailSearcher.new ENV['PAYPAL_EMAIL_ADDRESS'], ENV['PAYPAL_EMAIL_PASSWORD']
    gmail.process_all do |imap, uid, source| 
      insert_record(source)        
      # archive_email(imap, uid)
    end
  end
  
  def guessed_amount_paid
    text = find_text(/received a payment of .* AUD from/)
    text[/\d+\.\d+/]
  end
  
  def guessed_email
    text = tmail.from.first
  end
  
  def guessed_name
    text = find_text(/Buyer\:.*/)
    text.sub(/Buyer\:/, '')
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
  
  def self.insert_record(source)
    paypal_email = new :source => source
    paypal_email.save!
  end

  def self.archive_email(imap, uid)
    imap.uid_copy(uid, "[Gmail]/All Mail")
    imap.uid_store(uid, "+FLAGS", [:Deleted])
  end
  
end
