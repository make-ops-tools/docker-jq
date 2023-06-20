FROM alpine:3.18.2

RUN set -ex; \
    \
    apk --no-cache add \
        jq=1.6-r3

ENTRYPOINT [ "jq" ]

### METADATA ###################################################################

ARG IMAGE
ARG BUILD_DATE
ARG BUILD_VERSION
ARG GIT_URL
ARG GIT_BRANCH
ARG GIT_COMMIT_HASH
LABEL \
    sh.makeops.image=$IMAGE \
    sh.makeops.build-date=$BUILD_DATE \
    sh.makeops.build-version=$BUILD_VERSION \
    sh.makeops.git-url=$GIT_URL \
    sh.makeops.git-branch=$GIT_BRANCH \
    sh.makeops.git-commit-hash=$GIT_COMMIT_HASH
