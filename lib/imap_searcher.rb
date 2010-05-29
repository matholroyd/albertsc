require 'net/imap'
require 'net/http'

class IMAPSearcher
  def initialize(options)
    DBC.require_not_blank(options[:username])
    DBC.require_not_blank(options[:password])
    DBC.require_not_blank(options[:server])
    DBC.require(options[:port])
    DBC.require_not_blank(options[:mail_folder])

    options[:use_ssl] = true if options[:use_ssl].nil?
        
    @options = options
  end

  def process_inbox
    puts 'Starting to process emails...'
    with_imap do |imap|
      imap.select('INBOX')
      imap.uid_search(['NOT', 'DELETED']).each do |uid|
        source = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']
        yield(imap, uid, source)
      end
    end
    puts 'Finished processing emails'
  end
    
  def search(keywords, options = {})
    options[:timeout] ||= 10.seconds
    start = Time.now
    
    result = :normal

    with_imap do |imap|
      imap.uid_search(search_options(keywords)).each do |uid|
        source = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']
        should_keep_running = yield(source)
        
        unless should_keep_running
          result = :signalled_should_stop
          break
        end
        
        if Time.now > options[:timeout].since(start)
          result = :timeout
          break
        end
      end
    end
    
    result.to_s
  end
  
  def can_connect?
    result = true
    
    begin
      imap = Net::IMAP.new(@options[:server], @options[:port], @options[:use_ssl])
      imap.login(@options[:username], @options[:password])
      imap.logout
    rescue => e
      result = false
    end
  end
  
  protected
  
  def search_options(keywords)
    result = ['NOT', 'DELETED']
    keywords = keywords.split(/[\s|,]+/)
    keywords.collect do |k|
      result += ['OR', 'BODY', k, 'OR', 'SUBJECT', k, 'TO', k]
    end
    result
  end
  
  def with_imap
    imap = Net::IMAP.new(@options[:server], @options[:port], @options[:use_ssl])
    imap.login(@options[:username], @options[:password])
    imap.select(@options[:mail_folder])
    yield(imap)
    imap.logout
  end

end

class GMailSearcher < IMAPSearcher
  def initialize(username, password)
    options = {}
    options[:server] = 'imap.gmail.com'
    options[:port] = 993
    options[:use_ssl] = true
    options[:mail_folder] = 'Inbox'
    options[:username] = username
    options[:password] = password
    super(options)
  end
  
  def self.can_connect?(username, password)
    if username.blank? || password.blank?
      false
    else
      gmail = new username, password
      gmail.can_connect?
    end
  end
  
end