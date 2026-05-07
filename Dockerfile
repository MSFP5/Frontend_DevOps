# ETAPA 1: Build
FROM node:18-alpine AS build-stage
WORKDIR /app
COPY front_despacho/package*.json ./
RUN npm install
COPY front_despacho/ ./
RUN npm run build

# ETAPA 2: Producción
FROM nginx:stable-alpine

# Crear usuario y grupo según la pauta
RUN addgroup -S innovatech && adduser -S scott -G innovatech

# Copiar configuración personalizada y archivos del build
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Asegurar que scott sea dueño de TODO lo que Nginx necesita tocar
RUN chown -R scott:innovatech /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /tmp

USER scott
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
