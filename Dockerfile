FROM pm4-base:local

WORKDIR /tmp

RUN wget https://github.com/iangabrielsanchez/processmaker/archive/refs/tags/v4.1.21-arm64.zip
RUN unzip v4.1.21-arm64.zip && rm -rf /code/pm4 && mv processmaker-4.1.21-arm64 /code/pm4

WORKDIR /code/pm4
RUN composer install
COPY build-files/laravel-echo-server.json .
RUN npm install --unsafe-perm=true && npm run dev

COPY build-files/laravel-echo-server.json .
COPY build-files/init.sh .

# Prevents https://github.com/ProcessMaker/processmaker/issues/4454 from happening
RUN echo "echo \"SESSION_DOMAIN=\" >> .env" >> init.sh

CMD bash init.sh && supervisord --nodaemon