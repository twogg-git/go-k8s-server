# FROM golang:1.14.15-alpine
# ADD /src/main.go .
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
# # CMD ["go", "run", "main.go"]
# EXPOSE 8080
# CMD [ "./main" ]
# # ENTRYPOINT [ "/main" ]


FROM golang:1.14.15-alpine as development
RUN mkdir /app
COPY /src/main.go /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
CMD ["go", "run", "/app/main.go"]

FROM alpine:3.8 as production
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=development /app .
EXPOSE 8080
CMD ["/main.go"]