{
  networking.nameservers = [
    "45.90.28.0#***REMOVED***.dns.nextdns.io"
    "2a07:a8c0::#***REMOVED***.dns.nextdns.io"
    "45.90.30.0#***REMOVED***.dns.nextdns.io"
    "2a07:a8c1::#***REMOVED***.dns.nextdns.io"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
