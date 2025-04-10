# ohdsi-achilles-image

Docker image for running Achilles in a container

## Building the image

```shell
docker build --tag achilles:v1.7.2 --tag achilles:latest .
```

## Running a container

```shell
docker run -it achilles:latest
```
## Running Achilles

The analyses are run in one SQL session and all intermediate results are written to temp tables before finally being combined into the final results tables. Temp tables are dropped once the package is finished running.

See the [DatabaseConnector](https://github.com/OHDSI/DatabaseConnector) package for details on settings the connection details for your database:

```r
library(Achilles)
connectionDetails <- createConnectionDetails(
  dbms="redshift",
  server="server.com",
  user="secret",
  password='secret',
  port="5439")
```

```r
Achilles::achilles(
    cdmVersion = "5.4",
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = "yourCdmSchema",
    resultsDatabaseSchema = "yourResultsSchema"
)
```
The cdmDatabaseSchema parameter, and resultsDatabaseSchema parameter, are the fully qualified names of the schemas holding the CDM data, and targeted for result writing,  respectively.

The SQL platforms supported by [DatabaseConnector](https://github.com/OHDSI/DatabaseConnector) and [SqlRender](https://github.com/OHDSI/SqlRender) are the **only** ones supported here in Achilles as `dbms`.

### valid dbms names include:

* postgresql
* redshift
* sql server
* oracle
* spark
* snowflake
* bigquery
* iris

## References

* [Code Repository](https://github.com/OHDSI/Achilles)
* [Package Site](https://ohdsi.github.io/Achilles/)
* [Hades](https://ohdsi.github.io/Hades/)
* [OMOP Common Data Model](https://ohdsi.github.io/CommonDataModel/)
