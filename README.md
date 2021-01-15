# Jekyll-EWP

[![Gem Version](https://badge.fury.io/rb/JekyllEWP.svg)](https://badge.fury.io/rb/JekyllEWP)

A jekyll plugin to generate [Paypal Encrypted Web payment](https://developer.paypal.com/docs/paypal-payments-standard/integration-guide/encryptedwebpayments/#id08A3I0QC0X4) buttons on the fly.

*NOTE:* This plugin is **NOT compatible with GitHub Pages** and requires a PayPal business or sandbox account in order to generate or download the appropriate certificates to make this plugin work.

## Demo
There is a demo page available in the demo folder to show how it works. However, because this plugin is incompatible with Github Pages and requires a PayPal account, I cannot host a demo.

The `run.sh` file in the demo provides a place to put the required environment variables that make the plugin work.

## Installation

JekyllEWP is now available as a [Ruby Gem](https://rubygems.org/gems/JekyllEWP)!

You can either run `gem install JekyllEWP` to install or add `gem 'JekyllEWP', '~> 1.0', '>= 1.0.1'` to your `Gemfile`


## How To Use
See the [setup](https://github.com/MoralCode/Jekyll-EWP/wiki/Setup) page on the wiki for full setup and configuration instructions.



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


## Docs

I guess rubydoc also automatically compiles inline docs for you. neat.

https://www.rubydoc.info/gems/JekyllEWP