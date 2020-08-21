FROM alpine:3.12

ENV APP_HOME /app
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

RUN apk update \
    && apk add --no-cache ruby-full ruby-dev build-base \
    && gem install bundler:1.17.2 --no-document \
    && rm /var/cache/apk/* \
    && mkdir $APP_HOME

WORKDIR $APP_HOME
COPY . $APP_HOME/
RUN bundle install

CMD ["puma"]
