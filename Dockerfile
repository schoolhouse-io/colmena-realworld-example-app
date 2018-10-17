FROM ruby:2.5-alpine
MAINTAINER SchoolHouse.io <support@schoolhouse.io>

# Set working directory
WORKDIR /app

# Install Linux dependencies
ENV build_deps "gcc g++ make cmake libc-dev linux-headers"
ENV runtime_deps "bash"
ENV test_deps "sqlite-dev"

RUN apk --no-cache add ${build_deps} ${runtime_deps} ${test_deps}

# Add Gemfiles
COPY Gemfile* /app/

RUN bundle config --global jobs $(expr $(getconf _NPROCESSORS_ONLN) - 1) \
	&& bundle install

# Add application
ADD . /app

CMD ["/app/bin/start"]
