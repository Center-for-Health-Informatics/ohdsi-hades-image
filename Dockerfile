FROM debian:bookworm-slim
ENV DATABASECONNECTOR_JAR_FOLDER=/usr/local/share/jdbc/drivers
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
    r-cran-remotes \
    r-cran-rsqlite
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/CommonDataModel", upgrade = "always")'
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/Achilles", upgrade = "always")'
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/DataQualityDashboard", upgrade = "always")'
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/ETL-Synthea", upgrade = "always")'
RUN /usr/bin/R -e 'DatabaseConnector::downloadJdbcDrivers("sql server")'
RUN /usr/bin/R -e 'DatabaseConnector::downloadJdbcDrivers("postgresql")'
COPY final_visit_ids.sql /usr/local/lib/R/site-library/ETLSyntheaBuilder/sql/sql_server/cdm_version/v540/
COPY insert_person.sql /usr/local/lib/R/site-library/ETLSyntheaBuilder/sql/sql_server/cdm_version/v540/
USER ohdsi
WORKDIR /home/ohdsi
COPY --chown=ohdsi .Rprofile /home/ohdsi/
CMD [ "/usr/bin/R", "--no-save"]
