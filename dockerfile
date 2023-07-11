# Build stage
FROM node:lts-alpine as build
WORKDIR /app
COPY package*.json ./
RUN  npm install
COPY . .
RUN  npm run build

# Production stage
FROM nginx:alpine as production

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN  adduser --system --no-create-home --disabled-login --group nginx && \
     chown -R nginx:nginx /usr/share/nginx/html

USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]