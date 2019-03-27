# Jekyll-EWP
A jekyll plugin to generate and encrypt paypal buttons on the fly.

*NOTE:* This plugin is **NOT** compatible with github-pages



## How To Use
1. Download or clone the repository
2. Copy the `jekyllEWP.rb` file into the `_plugins` folder on your jekyll site
3. Add the following options to your `_config.yml`:
```
paypal_cert_id:
paypal_email_address:
paypal_sandbox_mode:
```
4. Make sure you have `name` and `price` values set in the frontmatter of the page where these buttons will appear
5. Add the tag to your page (see below)

## Basic Usage Examples

add to cart button

![add to cart button](https://www.paypalobjects.com/en_US/i/btn/btn_cart_LG.gif)

`{% EWPform addtocart false https://www.paypalobjects.com/en_US/i/btn/btn_cart_LG.gif %}`

view cart button

![view cart button](https://www.paypalobjects.com/en_US/i/btn/btn_viewcart_LG.gif)

`{% EWPform viewcart false https://www.paypalobjects.com/en_US/i/btn/btn_viewcart_LG.gif %}`

buy now button

![buy now button](https://www.paypalobjects.com/en_US/i/btn/btn_buynow_LG.gif)

`{% EWPform buynow false https://www.paypalobjects.com/en_US/i/btn/btn_buynow_LG.gif %}`


donate

![add to cart button](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)

`{% EWPform donate false https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif %}`



More information on the Tag Syntax can be found on the [wiki](https://github.com/MoralCode/Jekyll-EWP/wiki).
