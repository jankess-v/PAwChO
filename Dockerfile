#Etap 1
FROM scratch as base
#Rozpakowanie obrazu alpine rootfs w katalogu głównym kontenera
ADD alpine-minirootfs-3.21.3-aarch64.tar.gz /

#Wersja aplikacji
ARG VERSION="1.0.0"

#Instalacja Node.js i npm
RUN apk add --no-cache nodejs npm

#Ustawienie katalogu roboczego
WORKDIR /app

#Skopiowanie aplikacji do /app
COPY ./package.json .
RUN npm install

COPY ./server.js .

#Etap 2
FROM nginx:latest
#Ustawienie zmiennej środowiskowej w celu wyświetlenia na stronie
ARG VERSION="1.0.0"
ENV APP_VERSION=$VERSION
#Zainstalowanie node na nginx
RUN apt-get install -y curl && \
	curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \ 
	apt-get install -y nodejs

#Kopiowanie aplikacji z etapu 1
COPY --from=base /app /usr/share/nginx/html

# Konfiguracja Nginx do obsługi aplikacji
COPY nginx.conf /etc/nginx/nginx.conf

#Ustawienie katalogu jako roboczego i uruchomienie w nim aplikacji
WORKDIR /usr/share/nginx/html
CMD ["sh", "-c", "node server.js & nginx -g 'daemon off;'"]

#Informacja o porcie na którym działa aplikacja
EXPOSE 3000

#Automatyczne sprawdzanie działania aplikacji
HEALTHCHECK --interval=30s --timeout=10s \
	CMD curl -f http://localhost:3000 || exit 1