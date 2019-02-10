# Phone home

Docker image to determine your public IP address and update a DNS record hosted on Cloudflare. Great for hosting your own webserver at home!

## Usage

Update the environment variable values and then `make run` which handles the building and running of the docker image.

```sh
AUTH_KEY="XXXXXXX" \
AUTH_EMAIL="me@blah.com" \
ZONE_NAME="example.com" \
RECORD_NAME="home.example.com" \
make run
```

Have a look within the `Makefile` if you want to run the image yourself.

# Licence

MIT

***

By [David Winter](https://davidwinter.me)
