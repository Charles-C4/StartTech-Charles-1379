# ---- Build stage ----
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Install git (needed for go mod sometimes)
RUN apk add --no-cache git

# Copy go mod files first (cache-friendly)
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o muchtodo ./cmd/api

# ---- Runtime stage ----
FROM alpine:latest

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/muchtodo .

# Expose API port (adjust if your app uses another)
EXPOSE 8080

# Run the app
CMD ["./muchtodo"]

