# Try migration to OpenSSL #53891
https://github.com/JuliaLang/julia/pull/53891

1. Ideally, on Windows and macOS, everyone should be using the system TLS engine and CA cert store, which doesn't correspond to any CA cert file at all.
2. Does that mean we would simply not use OpenSSL at all on those systems? Or do we need to build OpenSSL to use the system cert checking?
3. Then the next question is whether Python can even be made to use the system TLS engine or not? If so, then that's what it should do.





## system certificate

Python loads the system certificate on Windows and sets the certificate path on other platforms.
[load_default_certs - doc](https://docs.python.org/3/library/ssl.html#ssl.SSLContext.load_default_certs),
[load_default_certs - src](https://github.com/python/cpython/blob/2402715e10d00ef60fad2948d8461559d084eb36/Lib/ssl.py#L532)

OpenSSL TLS Doc: 
https://www.openssl.org/docs/manmaster/man7/ossl-guide-tls-introduction.html#TRUSTED-CERTIFICATE-STORE

### Linux/macOS
> If you have obtained your copy of OpenSSL from an Operating System (OS) vendor (e.g. a Linux distribution) then normally the set of CA certificates will also be distributed with that copy.

- It seems that OpenSSL uses its own CA certificates on macOS just like on Linux, which needs to be confirmed:
    - "A CA file has been bootstrapped using certificates from the system keychain." —— [brew install openssl@3](https://formulae.brew.sh/formula/openssl@3)
    - [Syncing macOS Keychain certificates with Homebrew's OpenSSL](https://akrabat.com/syncing-macos-keychain-certificates-with-homebrews-openssl/)


### Windows
> If you are running your version of OpenSSL on Windows then OpenSSL (from version 3.2 onwards) will use the default Windows set of trusted CAs.

- Need: OpenSSL 3.2 + configure opt: `winstore`

### source build
> If you have built your version of OpenSSL from source, or obtained it from some other location and it does not have a set of trusted CA certificates then you will have to obtain them yourself. One such source is the Curl project.


## OpenSSL 3.0
OpenSSL.v3.0.13
```

```
