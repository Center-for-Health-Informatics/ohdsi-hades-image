FROM debian:bookworm-slim
RUN apt-get update && apt-get --yes install openjdk-17-jdk libxml2-dev libssl-dev libcurl4-openssl-dev libgit2-dev r-base r-base-dev r-cran-rjava r-cran-remotes
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/Achilles", upgrade = "always")'
CMD [ "/usr/bin/R" ]
