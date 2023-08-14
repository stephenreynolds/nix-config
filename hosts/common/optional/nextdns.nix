let
  nameservers = [
    "45.90.28.0#***REMOVED***.dns.nextdns.io"
    "2a07:a8c0::#***REMOVED***.dns.nextdns.io"
    "45.90.30.0#***REMOVED***.dns.nextdns.io"
    "2a07:a8c1::#***REMOVED***.dns.nextdns.io"
  ];
in
{
  networking.nameservers = nameservers;

  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    fallbackDns = nameservers;
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
