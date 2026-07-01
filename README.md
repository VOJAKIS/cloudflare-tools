# cloudflare-tools
Tools for interacting with Cloudflare – mainly for updating DNS.

## IP Getter API showdown

We have a clear winner – https://icanhazip.com/

| API Provider URL               | Time (seconds)                                                   | Average time (seconds) | Fastest |
| ------------------------------ | ---------------------------------------------------------------- | ---------------------- | ------- |
| https://icanhazip.com/         | 0,084946 <br> 0,079525 <br> 0,078444 <br> 0,075103 <br> 0,075331 | 0,08                   | ✅       |
| https://checkip.amazonaws.com/ | 0,363329 <br> 0,236609 <br> 0,183899 <br> 0,175393 <br> 0,194973 | 0,23                   | ❌       |
| https://ifconfig.me/ip         | 0,483939 <br> 0,235819 <br> 0,236638 <br> 0,237974 <br> 0,234267 | 0,29                   | ❌       |

## Environment file

The `.env` file is located in this directory (right here), hmm, like `./.env`

| Variable name            | Required | Default value | Description                                                                                  |
| ------------------------ | -------- | ------------- | -------------------------------------------------------------------------------------------- |
| CHECK_INTERVAL           | Yes      | 5m            | In what time interval is the script going to check IP change, s=seconds, m=minutes           |
| CLOUDFLARE_DOMAIN_NAME   | Yes      |               | The domain name, that you want to update.                                                    |
| CLOUDFLARE_ZONE_ID       | Yes      |               | Domain's Cloudflare Zone ID, usually located in the domain `Overview` section at the bottom. |
| CLOUDFLARE_DNS_RECORD_ID | Yes      |               | Same as Resource ID from Audit logs.                                                         |
| CLOUDFLARE_API_TOKEN     | Yes      |               | The domain's rightful owner's API token.                                                     |
