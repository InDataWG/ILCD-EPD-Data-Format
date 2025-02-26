# ILCD-EPD Data Format Documentation

Welcome to the ILCD+EPD Data Format documentation. This README provides a comprehensive overview of the format, along with essential links, references, and resources.

## ILCD+EPD Guides

**[ILCD+EPD Data Format Introduction](/doc/guides/ILCD-EPD_Data_Format_Introduction.md)**<br/>
This document provides an overview of the ILCD+EPD data format, its object-oriented structure, dataset types, and referencing system. It explains how Environmental Product Declarations (EPDs) are modeled and linked, along with API usage for accessing and querying datasets.

**[Developer Quick Start Guide](/doc/guides/EPD%20Data%20Format%20–%20Developer%20Quick%20Start%20Guide.md)**<br/>
This document serves as a starting point for software developers who want to integrate support for the ÖKOBAUDAT’s EPD data format and/or data exchange to or from the ÖKOBAUDAT into their software applications.
 
**[Migration Guide from v1.1 to v1.2](/doc/guides/EPD%20Data%20Format%20–%20Migration%20Guide%20from%201.1%20to%201.2.md)**<br/>
This document is a migration guide outlining the changes from ILCD+EPD format version 1.1 to 1.2.

**[Technical Details](/doc/guides/EPD%20Data%20Format%20–%20Technical%20Details.md)**<br/>
This document provides additional information for software developers who want to integrate support for the ILCD+EPD data format into their software applications.


## Schemas
XML schemas are used to formally describe the XML syntax and data types. They are also used to validate instance documents (i.e. ILCD+EPD datasets). They can also be used as a basis for generating classes for software applications that read and/or write ILCD+EPD data.

| Schema Name | Go to Source Code (XSD) | View HTML Documentation in the Browser |
|-------------|-------------------|-----------------------------------|
| EPD_DataSet.xsd | [Source Code](./schemas/EPD_DataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/EPD_DataSet.html) |
| ILCD_FlowDataSet.xsd | [Source Code](./schemas/ILCD_FlowDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/EPD_FlowDataSet.html) |
| ILCD_Common_DataTypes.xsd | [Source Code](./schemas/ILCD_Common_DataTypes.xsd ) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_Common_DataTypes.html) |
| ILCD_Common_EnumerationValues.xsd | [Source Code](./schemas/ILCD_Common_EnumerationValues.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_Common_EnumerationValues.html) |
| ILCD_ContactDataSet.xsd | [Source Code](./schemas/ILCD_ContactDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_ContactDataSet.html) |
| ILCD_FlowPropertyDataSet.xsd | [Source Code](./schemas/ILCD_FlowPropertyDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_FlowPropertyDataSet.html) |
| ILCD_LCIAMethodDataSet.xsd | [Source Code](./schemas/ILCD_LCIAMethodDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_LCIAMethodDataSet.html) |
| ILCD_LCIAMethodDataSet.xsd | [Source Code](./schemas/ILCD_LCIAMethodDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_SourceDataSet.html) |
| ILCD_UnitGroupDataSet.xsd | [Source Code](./schemas/ILCD_UnitGroupDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/schemadoc/ILCD_UnitGroupDataSet.html) |


## Authoritative Identifiers (UUIDs)

The ILCD data format is an object-oriented format (see [ILCD+EPD Data Format Introduction](/doc/guides/ILCD-EPD_Data_Format_Introduction.md)). Some objects are very often reused and have a authoritative character (master data), e.g. for units, LCIA methods, background databases/versions etc. They ensure consistency across datasets.
Each object has their individual UUID. The most important UUIDs are listed here for reference. You can view or download these lists in CSV format.
All master data can be found in a dedicated [repository](https://github.com/InDataWG/ILCD-EPD-Master-Data) 

| Reference Type                         | View HTML in the Browser                         | View CSV Source                              |
|----------------------------------------|--------------------------------------------------|------------------------------------------------|
| Common references                      | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/Common_references.html)     | [⬇ Download CSV](./doc/identifiers/Common_references.csv "download")       |
| Flow properties and unit groups        | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/Flow_properties_and_unit_groups.html) | [⬇ Download CSV](./doc/identifiers/Flow_properties_and_unit_groups.csv "download")|
| EN15804+A1 indicators                  | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/EN15804+A1_indicators.html) | [⬇ Download CSV](./doc/identifiers/EN15804+A1_indicators.csv "download")|
| EN15804+A2 (EF3.0) indicators          | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/EN15804+A2_EF3.0_indicators.html) | [⬇ Download CSV](./doc/identifiers/EN15804+A2_EF3.0_indicators.csv "download")|
| EN15804+A2 (EF3.1) indicators          | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/EN15804+A2_EF3.1_indicators.html) | [⬇ Download CSV](./doc/identifiers/EN15804+A2_EF3.1_indicators.csv "download")|
| Country-specific indicators            | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/Country-specific_indicators.html)  | [⬇ Download CSV](./doc/identifiers/Country-specific_indicators.csv "download") |
| ecoinvent database: source data sets   | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/BackgroundDB_SourceDatasets_ecoinvent.html)  | [⬇ Download CSV](./doc/identifiers/BackgroundDB_SourceDatasets_ecoinvent.csv "download")    |
| GaBi database: source data sets        | [View Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/feature/v1.3-alpha_en-15804/identifiers/BackgroundDB_SourceDatasets_GaBi.html) | [⬇ Download CSV](./doc/identifiers/BackgroundDB_SourceDatasets_GaBi.csv "download")  |


## Example dataset

A simple [example ILCD+EPD process dataset](./sample_data/processes/EPDv1.3_example_57a4ae65-d305-421e-b21f-a3f0c35b8abe.xml) can be found in the [sample_data](./sample_data) folder of this repository. 


## Validation

### ILCD Validation Tool

In order to make sure that a given ILCD+EPD dataset is compliant with both the XML Schemas and the ILCD+EPD master data, it can be validated using the [ILCD Validation Tool](https://bitbucket.org/okusche/ilcdvalidationtool/wiki/Home), a free and Open Source desktop tool available for all major operating systems. You will need to use a validation profile specific for ILCD+EPD (see next subsection).

For developers, the underlying logic for validating ILCD+EPD data against a given validation profile is also available as an Open Source Java library: [ILCD Validation Library](https://bitbucket.org/okusche/ilcdvalidation/)

### Validation profiles

The generic profile for ILCD+EPD v1.2 for EN 15804+A1 and +A2 (EF3.0 and EF3.1) compliant data is available [here](https://repo1.maven.org/maven2/com/okworx/ilcd/validation/profiles/EPD-1.2-Generic-EN15804/2.2.0/EPD-1.2-Generic-EN15804-2.2.0.jar).

The profile with additionl specific rules for the [ÖKOBAUDAT](https://www.oekobaudat.de/) database is available [here](https://repo1.maven.org/maven2/com/okworx/ilcd/validation/profiles/EPD-1.2-OEKOBAUDAT/3.5.0/EPD-1.2-OEKOBAUDAT-3.5.0.jar).





