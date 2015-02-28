# CanadaPost REST API V3 Wrapper

A Ruby wrapper for the CanadaPost REST API. Based extensively off the [fedex](https://github.com/jazminschroeder/fedex) gem.
Thanks to [jazminschroeder](https://github.com/jazminschroeder) and all contributors who helped make that a gem worth recreating for the Canada Post API

For more info see the [Official Canada Post Developer Docs](https://www.canadapost.ca/cpotools/apps/drc/home)

Current implementation for the rates endpoint only, feel free to let me know if there are other services you would like to see included or make a PR

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'canada-post-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install canada-post-api

## Usage

Require the gem:

```ruby
require 'canada_post'
```

Create a service:

```ruby
canada_post_service = CanadaPost::Shipment.new( username: 'xxxx',
									password: 'xxxx',
									customer_number: 'xxxx',
									mode: 'development' )
# mode can be 'development' or 'production'
```

### Define shipper:

```ruby
shipper = { postal_code: 'M5X1B8',
			country_code: 'CA' }
# Post Code is required for US and CA shipments, not for International Shipments
```

### Define recipient:

```ruby
recipient = { postal_code: 'M5R1C6',
			  country_code: 'CA' }
```

### Define package:

```ruby
package = { weight: { value: 1, units: 'KG' },
            dimensions: { length: 25, width: 15, height: 10, units: 'CM' } }
# weight is the only requirement for your package, Canada Post only accepts KG and CM for the time being
```

### To get service codes:
see [Canada Post Rating API docs](https://www.canadapost.ca/cpo/mc/business/productsservices/developers/services/rating/getrates/default.jsf) for service code descriptions
```ruby
$ CanadaPost::Request::Rate::SERVICE_CODES
$ => ["DOM.RP", "DOM.EP", "DOM.XP", "DOM.XP.CERT", "DOM.PC.CERT", "DOM.PC", "DOM.DT", "DOM.LIB", "USA.EP", "USA.PW.ENV", "USA.PW.PAK", "USA.PW.PARCEL", "USA.SP.AIR", "USA.TP", "USA.TP.LVM", "USA.XP", "INT.XP", "INT.IP.AIR", "INT.IP.SURF", "INT.PW.ENV", "INT.PW.PAK", "INT.PW.PARCEL", "INT.SP.AIR", "INT.SP.SURF", "INT.TP"] 
```

## Get Rates:

```ruby
$ rates = canada_post_service.rate( shipper: shipper,
                                    recipient: recipient,
                                    package: package)
```

Not specifying a service type will return an array of all available rates

```ruby
# complete response
$ [#<CanadaPost::Rate:0x007fd783f42a88 @service_type="Expedited Parcel", @service_code="DOM.EP", @total_net_charge="8.76", @total_base_charge="7.77", @gst_taxes="0.00", @pst_taxes="0.00", @hst_taxes="1.01", @transit_time="1">, #<CanadaPost::Rate:0x007fd783f42a60 @service_type="Priority", @service_code="DOM.PC", @total_net_charge="19.14", @total_base_charge="16.21", @gst_taxes="0.00", @pst_taxes="0.00", @hst_taxes="2.20", @transit_time="1">, #<CanadaPost::Rate:0x007fd783f42a10 @service_type="Regular Parcel", @service_code="DOM.RP", @total_net_charge="8.76", @total_base_charge="7.77", @gst_taxes="0.00", @pst_taxes="0.00", @hst_taxes="1.01", @transit_time="2">, #<CanadaPost::Rate:0x007fd783f429e8 @service_type="Xpresspost", @service_code="DOM.XP", @total_net_charge="11.31", @total_base_charge="9.58", @gst_taxes="0.00", @pst_taxes="0.00", @hst_taxes="1.30", @transit_time="1">] 
```

Specifying the service type will return one result

```ruby
$ service_type = 'DOM.EP'
$ rates = canada_post_service.rate( shipper: shipper,
                                    recipient: recipient,
                                    package: package,
                                    service_type: service_type)
# complete response
$ [
	#<CanadaPost::Rate:0x007fd783fea238 
		@service_type="Expedited Parcel", 
		@service_code="DOM.EP", 
		@total_net_charge="8.76", 
		@total_base_charge="7.77", 
		@gst_taxes="0.00", 
		@pst_taxes="0.00", 
		@hst_taxes="1.01", 
		@transit_time="1">
  ]
```

Your final amount will be under `total_net_charge`:

```ruby
$ rates.first.total_net_charge => '8.76' # all monetary values are CAD
```

This is still a work in progress but feel free to contribute if it will benefit you!


## Contributing

1. Fork it ( https://github.com/[my-github-username]/canada-post-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
