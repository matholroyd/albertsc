class PaypalEmail < ActiveRecord::Base
  validates_presence_of :source
  
  before_save :set_message_id  
  
  named_scope :processed, :conditions => {:processed => true}
  named_scope :not_processed, 'processed <> TRUE'
  
  def tmail
    @tmail ||= TMail::Mail.parse(source)
  end

  def self.import_pending
    DBC.require(GMailSearcher.can_connect?(ENV['PAYPAL_EMAIL_ADDRESS'], ENV['PAYPAL_EMAIL_PASSWORD']), 'bad email login')
    gmail = GMailSearcher.new ENV['PAYPAL_EMAIL_ADDRESS'], ENV['PAYPAL_EMAIL_PASSWORD']
    gmail.process_all do |imap, uid, source| 
      insert_record(source)        
      # archive_email(imap, uid)
    end
  end
  
  private 
  
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
