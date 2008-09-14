require 'eBayAPI'

$appId     = ''       
$devId     = ''
$certId    = ''
$authToken = ""

$eBay = EBay::API.new($authToken, $devId, $appId, $certId, :sandbox => true)

def find_product_in_ebay(number)
  $eBay.GetItem(:DetailLevel => 'ItemReturnAttributes', :ItemID => number, :IncludeWatchCount => 'true')
end