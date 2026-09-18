FROM  debian:trixie as stage-one

WORKDIR  /terra

ARG APP 

RUN apt-get update && apt-get install -y --no-install-recommends wget unzip ca-certificates \
&& wget -O /terra/terraform.zip  https://releases.hashicorp.com/terraform/${APP}/terraform_${APP}_linux_amd64.zip \
&& unzip /terra/terraform.zip -d  /terra/ \
&& chmod +x /terra/terraform \
&&  rm -fr  terraform.zip \ 
&&  rm -fr /var/lib/apt/lists/*

FROM alpine:3.23.5

COPY --from=stage-one /terra/terraform  /terra/

HEALTHCHECK   CMD test -x /terra/terraform init || exit 0

ENTRYPOINT ["/terra/terraform"]

CMD ["init"]


