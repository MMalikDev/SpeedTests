ARG VERSION=13-bookworm
FROM gcc:$VERSION AS builder
WORKDIR /code

# Compile code
COPY . .
RUN g++ -O3 -Wall -Wextra -pedantic -pthread -o app main.cpp

# Create a non-privileged user 
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "$UID" \
    code

# ------------------------------------------------------------ #

FROM builder AS testing
USER code

CMD [ "./app" ]
