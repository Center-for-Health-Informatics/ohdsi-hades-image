# OHDSI Hades Image

Docker image for running OHDSI Hades tools in a container

### Contents

* [This Image](#This)
* [DatabaseConnector](#DatabaseConnector)
* [Synthea ETL](#ETLSyntheaBuilder)
* [Achilles](#Achilles)
* [DataQualityDashboard](#DataQualityDashboard)


## This Image

### Building

```shell
docker build --tag hades:latest .
```

### Running a Container

```shell
docker run --name hades --volume `pwd`/home:/home/ohdsi --env TZ --env OMOP_SERVER --env OMOP_USER --env OMOP_PASSWORD --interactive --tty --rm hades:latest
```

This runs an R REPL with DatabaseConnector and some database drivers pre-loaded. The OHDSI/Hades tools mentioned in this document are pre-installed.


## DatabaseConnector

See the [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/) package for details on settings the connection details for your database. The drivers for `sql server`, `postgresql` and `sqlite` have been pre-loaded in this image.

```r
cd <- DatabaseConnector::createConnectionDetails(
  dbms          = "sql server",
  server        = "server;Database=db",
  user          = "user",
  password      = "password",
  extraSettings = "encrypt=true;trustServerCertificate=true;"
)
```


## ETLSyntheaBuilder

* [package website](https://ohdsi.github.io/ETL-Synthea/)
* get vocab from [Athena](https://athena.ohdsi.org/)
* [generate synthetic population](https://github.com/synthetichealth/synthea/wiki/Basic-Setup-and-Running)

### example

```shell
java -jar synthea-with-dependencies.jar --exporter.csv.export=true --exporter.fhir.export=false -p 1000 Ohio Cincinnati
```

```r
library(ETLSyntheaBuilder)

cdmVersion     <- "5.4"
syntheaVersion <- "3.3.0"
cdmSchema      <- "cdm"
syntheaSchema  <- "synthea"
syntheaFileLoc <- "/home/ohdsi/synthea"
vocabFileLoc   <- "/home/ohdsi/vocab"

ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, cdmSchema = cdmSchema, vocabFileLoc = vocabFileLoc)
ETLSyntheaBuilder::CreateMapAndRollupTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)
ETLSyntheaBuilder::CreateExtraIndices(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)
```


## Achilles

Automated Characterization of Health Information at Large-Scale Longitudinal Evidence Systems (ACHILLES) Achilles provides descriptive statistics on an OMOP CDM database. ACHILLES currently supports CDM version 5.3 and 5.4.

* [Code Repository](https://github.com/OHDSI/Achilles)
* [Package Site](https://ohdsi.github.io/Achilles/)

### run Achilles

```r
library(Achilles)

Achilles::achilles(
  cdmVersion = "5.4",
  connectionDetails = cd,
  cdmDatabaseSchema = "cdm",
  resultsDatabaseSchema = "achilles"
)
```

The cdmDatabaseSchema parameter, and resultsDatabaseSchema parameter, are the fully qualified names of the schemas holding the CDM data, and targeted for result writing, respectively.


## DataQualityDashboard

* [package website](https://ohdsi.github.io/DataQualityDashboard/)

```r
cdmDatabaseSchema <- "cdm" # the fully qualified database schema name of the CDM
resultsDatabaseSchema <- "dqd" # the fully qualified database schema name of the results schema (that you can write to)
cdmSourceName <- "Synthea synthetic health database" # a human readable name for your CDM source
cdmVersion <- "5.4" # the CDM version you are targetting. Currently supports 5.2, 5.3, and 5.4
outputFolder <- "output"
outputFile <- "results.json"

# run the job --------------------------------------------------------------------------------------
DataQualityDashboard::executeDqChecks(
  connectionDetails = cd,
  cdmDatabaseSchema = cdmDatabaseSchema,
  resultsDatabaseSchema = resultsDatabaseSchema,
  cdmSourceName = cdmSourceName,
  cdmVersion = cdmVersion,
  outputFolder = outputFolder,
  outputFile = outputFile)
```

## References

* [Hades](https://ohdsi.github.io/Hades/)
* [OMOP Common Data Model](https://ohdsi.github.io/CommonDataModel/)
