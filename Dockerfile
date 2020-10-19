FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
# RUN apt-get install -y locale-gen
# RUN locale-gen en_US.UTF-8


# install git
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y maven
RUN apt-get install -y wget
RUN apt-get install -y apt-utils

RUN apt-get install gnupg -y

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb &&  dpkg -i erlang-solutions_2.0_all.deb
RUN  apt-get update

RUN apt-get install esl-erlang -y
RUN apt-get install elixir
RUN if [ ! -e "timermanager-api" ]; then mix phx.new timermanager-api --app timer_manager --module Timermanager --no-html --no-webpack --binary-id; fi
RUN mix local.hex
RUN mix archive.install hex phx_new 1.5.6

COPY . .

# ENTRYPOINT ["java","-jar", "/Valereo_spring-boot/valereo/target/valereo-0.0.1-SNAPSHOT.jar"]
# ENTRYPOINT ["java","-cp","app:/Valereo_spring-boot/valereo/target/dependency/lib/*","com.marseille.valereo"]
