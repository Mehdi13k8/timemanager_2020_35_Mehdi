FROM elixir:latest

RUN mix local.hex --force

RUN mix local.rebar --force

RUN wget https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

RUN mix archive.install ./phoenix_new.ez --force

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get install -y -q nodejs

RUN apt install make -y

RUN apt-get install build-essential -y

RUN apt-get update && apt-get install -y \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*
