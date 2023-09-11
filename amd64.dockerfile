# :: Header
	FROM 11notes/node:stable
  ENV SSL_RSA_BITS=4096
  ENV SSL_ROOT=/api/ssl

# :: Run
	USER root
  
  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        openssl \
        openssh-client; \
      apk --no-cache upgrade;

	# :: prepare image
		RUN set-ex; \
      mkdir -p /api/ssl; \
      mkdir -p /api/lib;

  # :: install application
		RUN set -ex; \
			npm install --save --prefix /api \
        express;

    RUN set -ex; \
      openssl req -x509 -newkey rsa:${SSL_RSA_BITS} -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX" \
        -keyout "${SSL_ROOT}/key.pem" \
        -out "${SSL_ROOT}/cert.pem" \
        -days 3650 -nodes -sha256 &> /dev/null

	# :: copy root filesystem changes and add execution rights to init scripts
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin;
    
  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      chown -R 1000:1000 \
        /api;

# :: Volumes
	VOLUME ["/api/lib"]

# :: Start
	ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]