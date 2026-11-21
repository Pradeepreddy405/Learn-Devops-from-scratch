# 02 – DNS Record Types

DNS records store information in a DNS zone. Each record has a name, type, value, and often a TTL.

## 1. Common record types

| Record | Purpose | Example use |
|---|---|---|
| A | Maps a name to an IPv4 address | `app.example.com -> 192.0.2.10` |
| AAAA | Maps a name to an IPv6 address | IPv6 endpoint |
| CNAME | Makes one name an alias of another DNS name | `www.example.com -> example.com` |
| MX | Identifies mail exchangers for a domain | Receiving email |
| TXT | Stores text data | Domain verification, SPF, DKIM, DMARC |
| NS | Identifies authoritative nameservers for a zone/delegation | DNS delegation |
| SOA | Stores zone authority and timing metadata | Zone serial and refresh parameters |
| PTR | Maps an IP address to a hostname in reverse DNS | Reverse lookup |
| SRV | Identifies a service target and port | Service discovery |
| CAA | Restricts which certificate authorities may issue certificates for a domain | Certificate issuance policy |

Examples below use documentation-only IP addresses and illustrative names.

## 2. A record

Maps a hostname to an IPv4 address.

```dns
app.example.com.  300  IN  A  192.0.2.10
```

Lookup:

```bash
dig app.example.com A
```

## 3. AAAA record

Maps a hostname to an IPv6 address.

```dns
app.example.com.  300  IN  AAAA  2001:db8::10
```

Lookup:

```bash
dig app.example.com AAAA
```

## 4. CNAME record

Aliases one DNS name to another DNS name.

```dns
www.example.com.  300  IN  CNAME  app.example.com.
```

Important:
- A CNAME target is a DNS name, not an IP address.
- A CNAME owner name generally cannot have other ordinary data records at the same name.
- A CNAME cannot be placed at the zone apex in standard DNS because the apex must contain SOA and NS records.
- AWS Route 53 Alias is an AWS-specific alternative for supported targets, including certain zone-apex use cases.

## 5. MX record

Specifies mail exchangers. Lower preference numbers are preferred.

```dns
example.com.  300  IN  MX  10 mail1.example.com.
example.com.  300  IN  MX  20 mail2.example.com.
```

MX records do not themselves configure the mail server; the mail hostnames also need appropriate DNS and mail-service configuration.

## 6. TXT record

Stores text data, often used for domain ownership checks and email authentication.

Illustrative SPF record:

```dns
example.com.  300  IN  TXT  "v=spf1 include:mail.example.net -all"
```

Do not copy an SPF value from an example into production without confirming the actual email senders for the domain.

## 7. NS and SOA records

- NS records identify the authoritative nameservers for a zone or delegated child zone.
- SOA contains zone metadata such as the primary nameserver field, responsible-party field, serial number, and timing values.

Check nameservers:

```bash
dig example.com NS
```

Check SOA:

```bash
dig example.com SOA
```

## 8. PTR record

Used for reverse DNS. IPv4 reverse lookups use the `in-addr.arpa` namespace; IPv6 uses `ip6.arpa`.

```bash
dig -x 192.0.2.10
```

A PTR record is not automatically created just because an A record exists. Reverse DNS is managed by the authority responsible for the relevant IP range.

## 9. SRV and CAA records

SRV records identify a service target and port, with priority and weight fields.

```dns
_service._tcp.example.com. 300 IN SRV 10 5 5060 sip.example.com.
```

CAA records specify which certificate authorities are permitted to issue certificates for a domain.

```dns
example.com. 300 IN CAA 0 issue "letsencrypt.org"
```

The example CAA value is illustrative; use the policy required by your organization.

## 10. TTL

TTL is the number of seconds a DNS answer can be cached.

For example, a TTL of 300 allows a resolver to cache the answer for up to five minutes. Actual client behavior can also be influenced by resolver policies and application caches.

A lower TTL can make planned changes easier to roll out, but it can increase DNS query volume. Lowering TTL shortly before a change does not clear answers already cached under the previous TTL.

## 11. Practical commands

```bash
dig example.com A
dig example.com AAAA
dig example.com MX
dig example.com TXT
dig example.com NS
dig example.com SOA
dig -x 192.0.2.10
```

## 12. Interview questions

1. What is the difference between A and AAAA?
2. What is the difference between CNAME and an AWS Route 53 Alias?
3. Why can a standard CNAME not be used at the zone apex?
4. What are MX records used for?
5. How do TXT records help with email security and domain verification?
6. What does TTL control?

## 13. Key takeaway

Choose a record based on the data required: IP address, alias, mail routing, verification text, delegation, reverse lookup, service discovery, or certificate-authority policy. Verify the record type and target before making production changes.
