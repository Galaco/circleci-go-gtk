FROM circleci/golang:1.14

USER root

RUN apt-get update \ 
	&& apt-get install --no-install-recommends -y \
	gtk+3.0 \
	libgtk-3-dev \
	xvfb \
	&& rm -rf /var/lib/apt/lists/*

RUN export DISPLAY=:99.0 \
	&& /usr/bin/Xvfb $DISPLAY 2>1 > /dev/null &

RUN export GTK_VERSION=$(pkg-config --modversion gtk+-3.0 | tr . _| cut -d '_' -f 1-2) \
	&& export Glib_VERSION=$(pkg-config --modversion glib-2.0) \
	&& export Cairo_VERSION=$(pkg-config --modversion cairo) \
	&& export Pango_VERSION=$(pkg-config --modversion pango)

USER circleci

RUN GO111MODULE=on go get -v github.com/golangci/golangci-lint/cmd/golangci-lint