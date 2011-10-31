# encoding: UTF-8

class MailingsMailer < ActionMailer::Base
  
  # We need this, because we render the elements with render_elements helper
  helper :alchemy, :pages
  helper_method :logged_in?, :configuration
  
  def logged_in?
    false
  end
  
  def configuration(name)
    return Alchemy::Config.get(name)
  end
  
  # This renders the mail sent as newsletter to the recipient
  def my_mail(mailing, elements, contact, recipient, options = {})
    default_options = {
      :mail_from => AlchemyMailings::Config.get(:mail_from),
      :subject => mailing.subject,
      :server => "http://localhost:3000"
    }
    options = default_options.merge(options)
    
    @page = mailing.page
    @mailing = mailing
    @elements = elements
    @contact = contact
    @recipient = recipient
    @server = options[:server].gsub(/http:\/\//, '')
    @host = options[:server]
    
    mail(:to => contact.email, :from => options[:mail_from], :subject => options[:subject]) do |format|
      format.html { render("layouts/newsletters.html") }
      format.text { render("layouts/newsletters.text") }
    end
  end
  
  def verification_mail(contact, server, element, newsletter_ids)
    recipients contact.email
    from element.content_by_name("mail_from").ingredient
    subject element.content_by_name("mail_subject").ingredient
    content_type "text/html"
    body(
      :contact => contact,
      :server => server.gsub(/http:\/\//, ''),
      :element => element,
      :newsletter_ids => newsletter_ids
    )
  end
  
  def signout_mail(contact, server, element)
    recipients contact.email
    from element.content_by_name("mail_from").ingredient
    subject element.content_by_name("mail_subject").ingredient
    content_type "text/html"
    body(
      :contact => contact,
      :server => server.gsub(/http:\/\//, ''),
      :element => element
    )
  end
  
end
