# ohdsi-hades-image

Docker image for running OHDSI Hades tools in a container

## Building the image

```shell
docker build --tag hades:latest .
```

## Running a container

```shell
docker run -it --rm --name hades -e TZ=America/New_York hades:latest
```

This runs an R REPL with the Hades tools and some database drivers pre-loaded.

## Database Connections

See the [DatabaseConnector](https://github.com/OHDSI/DatabaseConnector) package for details on settings the connection details for your database. The drivers for `sql server`, `postgresql` and `sqlite` have been pre-loaded in this image.

```r
cd <- DatabaseConnector::createConnectionDetails(
  dbms          = "sql server",
  server        = "server;Database=db",
  user          = "user",
  password      = "password",
  extraSettings = "encrypt=true;trustServerCertificate=true;"
)
```

## Using Achilles

The analyses are run in one SQL session and all intermediate results are written to temp tables before finally being combined into the final results tables. Temp tables are dropped once the package is finished running.

The image preloads `library(Achilles)` from its .Rprofile file.

```r
Achilles::achilles(
    cdmVersion = "5.4",
    connectionDetails = cd,
    cdmDatabaseSchema = "yourCdmSchema",
    resultsDatabaseSchema = "yourResultsSchema"
)
```
The cdmDatabaseSchema parameter, and resultsDatabaseSchema parameter, are the fully qualified names of the schemas holding the CDM data, and targeted for result writing,  respectively.

## Using DataQualityDashboard

The image preloads `library(DataQualityDashboard)` from its .Rprofile file.

## References

* [Code Repository](https://github.com/OHDSI/Achilles)
* [Package Site](https://ohdsi.github.io/Achilles/)
* [Hades](https://ohdsi.github.io/Hades/)
* [OMOP Common Data Model](https://ohdsi.github.io/CommonDataModel/)
