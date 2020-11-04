FROM node:12.2.0-alpine

# set working directory
# WORKDIR /app

# # add `/app/node_modules/.bin` to $PATH
# ENV PATH /app/node_modules/.bin:$PATH

# # install and cache app dependencies
# COPY package.json /app/package.json

COPY . .

RUN apk add --no-cache git
RUN npm install
RUN npm install @vue/cli@3.7.0 -g
EXPOSE 8081

# start app
# CMD ["npm", "run", "serve"]


# Build for prod only
# # build environment
# FROM node:12.2.0-alpine as build
# WORKDIR /app
# ENV PATH /app/node_modules/.bin:$PATH
# COPY package.json /app/package.json
# RUN npm install --silent
# RUN npm install @vue/cli@3.7.0 -g
# COPY . /app
# RUN npm run build

# # production environment
# FROM nginx:1.16.0-alpine
# COPY --from=build /app/dist /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
