require 'openssl'
require 'base64' 


def wrapInForm(encryptedValue, use_sandbox=false, separate_submit=false, button_image = "", identifier="")

    if identifier.nil?
        identifier = ""
    end

    if button_image.nil?
        button_image = ""
    end

    if getBool(use_sandbox) == true
        stage = "sandbox."
    else
        stage=""
    end

    unless getBool(separate_submit) == true
        submit = '<input type="image" src="' + button_image + '" border="0" name="submit" alt="Make payments with PayPal - it\'s fast, free and secure!">'
        id=''
    else
        submit = ""
        id=' id="' + identifier + '"'
    end


    return_str = '<form' + id +' action="https://www.' + stage + 'paypal.com/cgi-bin/webscr" method="post">' + '<input type="hidden" name="cmd" value="_s-xclick">' + submit + '<input type="hidden" name="encrypted" value="' + encryptedValue + '"></form>';

    return return_str

end


 
def getButtonEncryptionValue(data, privateKeyData, certData, payPalCertData, keyPass)
    #puts data
    #get keys and certs

    #https://stackoverflow.com/a/11136771
    paypal_pub_cert = OpenSSL::X509::Certificate.new(payPalCertData)

    my_pub_cert = OpenSSL::X509::Certificate.new(certData)

    #https://stackoverflow.com/a/862090S
    my_private_key = OpenSSL::PKey::RSA.new(privateKeyData, keyPass)

       


    #modified from http://railscasts.com/episodes/143-paypal-security
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(my_pub_cert), OpenSSL::PKey::RSA.new(my_private_key, keyPass), data, [], OpenSSL::PKCS7::BINARY)
    
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(paypal_pub_cert)], signed.to_der, OpenSSL::Cipher.new("des-ede3-cbc"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")

    # puts signed.class
    return signed.to_pem()
        
end


def getButtonOptionsString(certID, cmd, paypal_business_email, item_name, item_price, item_number = "0000", currency_code = "USD", tax = nil, shipping = nil )
    options = ""

    options.concat("cert_id=" + certID + "\n")
    options.concat("cmd=" + cmd + "\n")

    # if cmd == "_cart"
        # case cart_options
        # when "add"
        # when "display"
        #     options.concat(cart_options + "=1\n")
        # when "upload"
        #     puts "unsupported value 'upload' used in paypal EWP plugin. the form probably isnt going to work"
        # end
    # end

    options.concat("business=" + paypal_business_email + "\n")
    options.concat("item_name=" + item_name + "\n")
    #options.concat("item_number=" + item_number + "\n")
    options.concat("amount=" + item_price + "\n")
    options.concat("currency_code=" + currency_code + "\n")
    


    unless tax.nil? || tax == "0"
        options.concat("tax=" + tax + "\n")
    end

    unless shipping.nil? || shipping == "0"
        options.concat("shipping=" + shipping + "\n")
    end



=begin
Below is the full list of supported key/vaue pairs from the paypal docs (https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/encryptedwebpayments/#id08A3I0PD04Y) the ones beginning with a hash (#) are not implemented here.

some of these are also passthrough variables that arent used by paypal: https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/formbasics/#variations-on-basic-variables


    cert_id=Z24MFU6DSHBXQ
    cmd=_xclick
    business=sales@company.com
    item_name=Handheld Computer
    #item_number=1234
    #custom=sc-id-789
    amount=500.00
    currency_code=USD
    tax=41.25
    shipping=20.00
    #address_override=1
    #address1=123 Main St
    #city=Austin
    #state=TX
    #zip=94085
    #country=USA
    #cancel_return=https://example.com/cancel
=end
    return options

end

#determines the button command from the string input.
#possible commands listed at https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/formbasics/#specifying-button-type--cmd

def getButtonCmd(purpose)
     
    case purpose
    when "addtocart"
        return "_cart\nadd=1" #this is a dirty hack to insert the correct parameter for the cart buttons. better solutions welcome
    when "viewcart"
        return "_cart\ndisplay=1" #this is a dirty hack to insert the correct parameter for the cart buttons. better solutions welcome
    when "buynow"
        return "_xclick"
    when "donate"
        return "_donations"
    when "autobilling"
        return "_xclick-auto-billing"
    when "paymentplan"
        return "_xclick-payment-plan"
    else
        return "_xclick"
    end

end

def getBool(val)
    val.to_s.downcase == 'true'
end 




module Jekyll
    class PayPalEWP < Liquid::Tag

               
  
        def initialize(tag_name, variables, tokens)
            super
            @variables = variables.split(" ")

            @buttonpurpose = @variables[0]

            unless @variables[1].nil?
                @separatesubmitbutton = getBool(@variables[1])
            else
                @separatesubmitbutton = false
            end

            
            unless @variables[2].nil?

                if @separatesubmitbutton == true
                    #is an id
                    @formid = @variables[2]
                else
                    #is an image
                    @buttonimage = @variables[2]
                end

            else
                #no value provided
                if @separatesubmitbutton == true
                    #is an id
                    @formid = 0
                else
                    #is an image
                    @buttonimage = "https://www.paypalobjects.com/en_US/i/btn/btn_cart_LG.gif" #some arbitrary thing
                end
                
            end

            
        end

        # Lookup allows access to the page/post variables through the tag context
        #https://blog.sverrirs.com/2016/04/custom-jekyll-tags.html
        def lookup(context, name)
            lookup = context
            name.split(".").each { |value| lookup = lookup[value] }
            lookup
        end
  
      def render(context)

        wrapInForm(
            getButtonEncryptionValue(
                getButtonOptionsString(
                    "#{lookup(context, 'site.paypal_cert_id')}",
                    getButtonCmd(@buttonpurpose),
                    "#{lookup(context, 'site.paypal_email_address')}",
                    "#{lookup(context, 'page.name')}", #product name
                    "#{lookup(context, 'page.price')}"), #product price
                    #"#{lookup(context, 'page.sku')}" #product identifier
                ENV['EWP_PRIVKEY'],
                ENV['EWP_PUBCERT'],
                ENV['EWP_PAYPAL_PUBCERT'],
                ENV['EWP_PRIVKEY_PASS']),
            "#{lookup(context, 'site.paypal_sandbox_mode')}",
            @separatesubmitbutton,
            @buttonimage,
            @formid)
      end
    end
  end
  
  Liquid::Template.register_tag('EWPform', Jekyll::PayPalEWP)
  