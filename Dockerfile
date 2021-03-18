FROM golang:1.14.15-alpine
COPY /src/main.go .
CMD ["go", "run", "main.go"]
