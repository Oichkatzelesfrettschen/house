# Base image with historical GHC
# This image should contain GHC 6.8.2 pre-installed.
FROM ghc:6.8.2

WORKDIR /house
COPY . /house

# Build using the legacy Makefile
RUN make boot && make

CMD ["/bin/bash"]
