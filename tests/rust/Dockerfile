ARG VERSION=1.75-slim-bookworm
FROM rust:$VERSION AS builder
WORKDIR /code

# Copy manifests
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

# Install dependencies
RUN cargo build --release
RUN rm -r src/ 

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

# ------------------------------ #

FROM builder AS development
USER code

COPY --from=builder /code/target/release/app .

CMD ["./app"]
