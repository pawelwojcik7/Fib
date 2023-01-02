FROM debian:stable-slim AS build
WORKDIR /opt
RUN apt update -y && apt install make yasm binutils -y
RUN apt install git -y
RUN git clone https://github.com/nemasu/asmttpd.git
RUN git clone https://github.com/pawelwojcik7/Fib
RUN cp -f /opt/Fib/index.html /opt/asmttpd/web_root/index.html
WORKDIR /opt/asmttpd
RUN make release

FROM scratch
COPY --from=build /opt/asmttpd/asmttpd /
COPY --from=build /opt/asmttpd/web_root /web_root
ENTRYPOINT ["/asmttpd"]
CMD ["/web_root", "8080"]
