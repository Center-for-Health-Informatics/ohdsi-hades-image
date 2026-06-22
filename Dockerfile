FROM debian:bookworm-slim
ENV DATABASECONNECTOR_JAR_FOLDER=/usr/local/share/jdbc/drivers
RUN adduser --disabled-password --gecos "" ohdsi
RUN apt-get update && \
    apt-get --yes install \
    ca-certificates \
    openjdk-17-jdk \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libgit2-dev \
    libuv1-dev \
    r-base \
    r-base-dev \
    r-cran-rjava \
    r-cran-remotes \
    r-cran-rsqlite
RUN echo 'options(repos = c(PPM = "https://packagemanager.posit.co/cran/__linux__/bookworm/latest", CRAN = "https://cloud.r-project.org"))' >> /etc/R/Rprofile.site
RUN printf '#!/bin/bash\nexec /usr/bin/g++ "${@/-fpic/-fPIC}"\n' > /usr/local/bin/g++ && chmod +x /usr/local/bin/g++
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/CommonDataModel", upgrade = "always")'
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/Achilles", upgrade = "always")'
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/DataQualityDashboard", upgrade = "always")'
RUN /usr/bin/R -e 'remotes::install_github("OHDSI/ETL-Synthea", upgrade = "always")'
RUN /usr/bin/R -e 'DatabaseConnector::downloadJdbcDrivers("sql server")'
RUN /usr/bin/R -e 'DatabaseConnector::downloadJdbcDrivers("postgresql")'
COPY final_visit_ids.sql /usr/local/lib/R/site-library/ETLSyntheaBuilder/sql/sql_server/cdm_version/v540/
COPY insert_person.sql /usr/local/lib/R/site-library/ETLSyntheaBuilder/sql/sql_server/cdm_version/v540/
COPY create_synthea_tables.sql /usr/local/lib/R/site-library/ETLSyntheaBuilder/sql/sql_server/synthea_version/v330/
RUN chmod -R 755 /usr/local/lib/R/site-library
USER ohdsi
WORKDIR /home/ohdsi
COPY --chown=ohdsi .Rprofile /home/ohdsi/
CMD [ "/usr/bin/R", "--no-save"]
