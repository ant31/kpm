FROM alpine:3.3

ARG version=0.23.1
ARG workdir=/opt/kpm
RUN rm -rf $workdir
RUN mkdir -p $workdir
ADD . $workdir

WORKDIR $workdir

RUN apk --update add python py-pip openssl ca-certificates git
RUN apk --update add --virtual build-dependencies python-dev build-base wget openssl-dev libffi-dev
RUN pip install pip -U
RUN pip install gunicorn -U \
  && python setup.py install



CMD ["kpm"]
