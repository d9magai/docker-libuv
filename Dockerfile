FROM centos
MAINTAINER d9magai

ENV LIBUV_VERSION v1.4.2
ENV LIBUV_ARCHIVE libuv-$LIBUV_VERSION.tar.gz
ENV LIBUV_PREFIX /opt/libuv

RUN yum update -y && yum install -y \
    tar \
    libtool \
    make \
    && yum clean all

RUN mkdir -p $LIBUV_PREFIX/src \
    && cd $LIBUV_PREFIX/src \
    && curl -sL http://libuv.org/dist/$LIBUV_VERSION/$LIBUV_ARCHIVE -o $LIBUV_ARCHIVE \
    && tar xf $LIBUV_ARCHIVE \
    && rm $LIBUV_ARCHIVE \
    && cd `basename $LIBUV_ARCHIVE .tar.gz` \
    && libtoolize -c \
    && ./autogen.sh \
    && ./configure --prefix=$LIBUV_PREFIX \
    && make \
    && make install \
    && rm -rf $LIBUV_PREFIX/src

RUN echo $LIBUV_PREFIX/lib/ > /etc/ld.so.conf.d/libuv.conf && ldconfig

ENV CMAKE_INCLUDE_PATH $LIBUV_PREFIX/include/:$CMAKE_INCLUDE_PATH
ENV CMAKE_LIBRARY_PATH $LIBUV_PREFIX/lib/:$CMAKE_LIBRARY_PATH

