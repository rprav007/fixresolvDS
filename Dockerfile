FROM alpine:3.5
ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.4/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN apk update
RUN apk add bash bind-tools curl ca-certificates
ENV HOME=/config
COPY copyresolv.sh /
RUN set -x && \
    chmod +x /usr/local/bin/kubectl && \
    adduser kubectl -Du 2342 -h /config && \
    kubectl version --client
CMD ["/bin/sh","/copyresolv.sh"]
