FROM centos
MAINTAINER d9magai

ENV LIBUV_PREFIX /opt/libuv
ENV LIBUV_VERSION v1.4.2
ENV LIBUV_BASENAME libuv-$LIBUV_VERSION
ENV LIBUV_ARCHIVE libuv-$LIBUV_VERSION.tar.gz
ENV LIBUV_ARCHIVE_URL http://libuv.org/dist/$LIBUV_VERSION/$LIBUV_ARCHIVE

RUN yum update -y && yum install -y \
    tar \
    libtool \
    make \
    && yum clean all

RUN mkdir -p $LIBUV_PREFIX/src \
    && cd $LIBUV_PREFIX/src \
    && curl -sL $LIBUV_ARCHIVE_URL -o $LIBUV_ARCHIVE \
    && tar xf $LIBUV_ARCHIVE \
    && cd $LIBUV_BASENAME \
    && libtoolize -c \
    && ./autogen.sh \
    && ./configure --prefix=$LIBUV_PREFIX \
    && make \
    && make install \
    && rm -rf $LIBUV_PREFIX/src

RUN echo $LIBUV_PREFIX/lib/ > /etc/ld.so.conf.d/libuv.conf && ldconfig

ENV CMAKE_INCLUDE_PATH $LIBUV_PREFIX/include/:$CMAKE_INCLUDE_PATH
ENV CMAKE_LIBRARY_PATH $LIBUV_PREFIX/lib/:$CMAKE_LIBRARY_PATH

