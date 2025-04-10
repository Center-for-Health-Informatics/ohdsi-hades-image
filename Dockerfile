FROM debian:bookworm-slim
RUN adduser --disabled-password --gecos "" ohdsi
RUN apt-get update && \
    apt-get --yes install \
    openjdk-17-jdk \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libgit2-dev \
    r-base \
    r-base-dev \
    r-cran-rjava \
    r-cran-remotes
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/Achilles", upgrade = "always")'
USER ohdsi
WORKDIR /home/ohdsi
COPY --chown=ohdsi .Rprofile /home/ohdsi/
RUN mkdir -p /home/ohdsi/jdbcDrivers
ENV DATABASECONNECTOR_JAR_FOLDER=/home/ohdsi/jdbcDrivers
CMD [ "/usr/bin/R", "--no-save"]
