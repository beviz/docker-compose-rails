FROM phusion/passenger-ruby22

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# for carrierwave
RUN apt-get install -y imagemagick

# for js runtime
RUN apt-get install -y nodejs

# tools
RUN apt-get install -y rsync
RUN apt-get install -y ghostscript
RUN apt-get install -y libav-tools

ENV HOME /root

CMD ["/sbin/my_init"]

EXPOSE 80

# enable ssh
RUN usermod -a -G docker_env app
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
EXPOSE 22

# Timezone
RUN echo Asia/Beijing > /etc/timezone
# RUN cp -f /usr/share/zoneinfo/Asia/Beijing /etc/localtime

# passenger
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD config.d/nginx.conf /etc/nginx/sites-enabled/default.conf
ADD config.d/rails_env.conf /etc/nginx/main.d/rails-env.conf

# add ssh keys
ADD authorized_keys /root/.ssh/
RUN chmod 600 /root/.ssh/authorized_keys

# install bundle
# WORKDIR /tmp
# ADD Gemfile /tmp/Gemfile
# ADD Gemfile.lock /tmp/Gemfile.lock
# RUN bundle install


# RUN mkdir /var/www
# ADD . /var/www
# RUN chown -R app:app /var/www
