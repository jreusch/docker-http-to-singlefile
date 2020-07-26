FROM node:buster

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    chromium chromium-driver \
    firefox-esr jq

COPY install-geckodriver.sh .
RUN ./install-geckodriver.sh

WORKDIR /app

# lets make the head commit sticky, just to have a stable image.
# current HEAD of master as of 26.7.2020
ENV COMMIT 9d30f296f66bdc8278a6d4f2c4cf951a8ea7c5ce
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
