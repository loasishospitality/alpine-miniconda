FROM gliderlabs/alpine

MAINTAINER CognitiveScale <devops@cognitivescale.com>

RUN apk update
RUN apk add -y wget bzip2 ca-certificates 
RUN apk add glib libxext  libxrender
RUN apk add --update bash && rm -rf /var/cache/apk/*
ENV CONDA_HOME=/data/opt/conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh 
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda-3.16.0-Linux-x86_64.sh 
RUN apk add --update curl && \
  curl -o glibc-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/8/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
  apk add --allow-untrusted glibc-2.21-r2.apk && \
  curl -o glibc-bin-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/8/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
  apk add --allow-untrusted glibc-bin-2.21-r2.apk && \
  /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk del curl && \
  rm -f glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
  rm -rf /var/cache/apk/*
RUN /bin/bash /Miniconda-3.16.0-Linux-x86_64.sh -b -p $CONDA_HOME 
RUN rm Miniconda-3.16.0-Linux-x86_64.sh 
RUN $CONDA_HOME/bin/conda install --yes conda==3.18.3

RUN apk add --update --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ tini
ENV PATH $CONDA_HOME/bin:$PATH

ENV LANG C.UTF-8

RUN apk add libstdc++
#RUN conda install -y mongodb
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.

#ENV TINI_VERSION v0.6.0
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
#RUN chmod +x /usr/bin/tini
#ENTRYPOINT ["/usr/bin/tini", "--"]


#ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
