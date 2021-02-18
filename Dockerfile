FROM node:buster

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    chromium chromium-driver \
    firefox-esr jq

COPY install-geckodriver.sh .
RUN ./install-geckodriver.sh

WORKDIR /app

# lets make the head commit sticky, just to have a stable image.
# current HEAD of master as of 18.2.2021
ENV COMMIT c7e25cf742809e133759afe043e59b8b8617eb9b
RUN git init && \
    git remote add origin  https://github.com/gildas-lormeau/SingleFile.git && \
    git fetch --depth 1 origin ${COMMIT} && \
    git checkout FETCH_HEAD && \
    cd cli && \
    chmod +x single-file && \
    npm install --production

WORKDIR /work
RUN chown 1000.1000 .
USER 1000:1000

#ENTRYPOINT ["/app/cli/single-file", "--browser-executable-path", "/usr/bin/chromium-browser", "--filename-template=''", "--browser-args", "[\"--no-sandbox\"]"]
#ENTRYPOINT ["/app/cli//single-file", "--filename-template=''", "--browser-args", "[\"--no-sandbox\"]"]
ENTRYPOINT ["/app/cli/single-file", "--filename-template=''"]
CMD ["https://www.tagesschau.de"]
