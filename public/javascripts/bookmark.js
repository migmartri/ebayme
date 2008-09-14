javascript:(function(){
  if (window.location.host == "cgi.sandbox.ebay.com"){
    var regexS = "[\\?&]"+'item'+"=([^&#]*)";
  }else
  {
    var regexS = "[\\?&]"+'hash'+"=([^&#]*)";    
  }
  var regex = new RegExp( regexS );
  var results = regex.exec( document.URL);
  results = results[1].replace("item", "");
url = "http://ebay.flowersinspace.com/products/new?item=" + results + "&min=" + document.getElementById("DetailsCurrentBidValue").firstChild.innerHTML;
w=window.open(url,'addwindow','status=no,toolbar=no,width=350,height=365,resizable=false');
;})();