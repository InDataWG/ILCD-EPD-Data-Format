# ILCD-EPD Data Format Documentation

Welcome to the ILCD+EPD Data Format documentation. This README provides a comprehensive overview of the format, along with essential links, references, and resources.

## Interactive Documentation

Browse the complete ILCD+EPD v1.3 format specification with an interactive table featuring:
- Search functionality across all fields
- Language toggle (English/German)
- Column show/hide controls
- Detailed attribute pages with full specifications
- CSV and AsciiDoc downloads

| Schema Name | Source (XSD) | Interactive Documentation |
|-------------|--------------|---------------------------|
| EPD Dataset | [Source](./schemas/EPD_DataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/doc/) |
| EPD Flow Dataset | [Source](./schemas/ILCD_FlowDataSet.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/EPD_FlowDataSet.html) |
| ILCD Contact Dataset | [Source](./schemas/ILCD_ContactDataSet.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_ContactDataSet.html) |
| ILCD Flow Property Dataset | [Source](./schemas/ILCD_FlowPropertyDataSet.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_FlowPropertyDataSet.html) |
| ILCD LCIA Method Dataset | [Source](./schemas/ILCD_LCIAMethodDataSet.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_LCIAMethodDataSet.html) |
| ILCD Source Dataset | [Source](./schemas/ILCD_SourceDataSet.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_SourceDataSet.html) |
| ILCD Unit Group Dataset | [Source](./schemas/ILCD_UnitGroupDataSet.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_UnitGroupDataSet.html) |
| ILCD Common Data Types | [Source](./schemas/ILCD_Common_DataTypes.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_Common_DataTypes.html) |
| ILCD Common Enumeration Values | [Source](./schemas/ILCD_Common_EnumerationValues.xsd) | [View Documentation](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/schemadoc/ILCD_Common_EnumerationValues.html) |

## ILCD+EPD Guides

**[Developer Quick Start Guide](/doc/guides/EPD%20Data%20Format%20–%20Developer%20Quick%20Start%20Guide.md)**<br/>
This document serves as a starting point for software developers who want to integrate support for the ÖKOBAUDAT's EPD data format and/or data exchange to or from the ÖKOBAUDAT into their software applications. [(Download)](/doc/guides/EPD%20Data%20Format%20–%20Developer%20Quick%20Start%20Guide.docx)

**[Migration Guide from v1.2 to v1.3](/doc/guides/EPD%20Data%20Format%20–%20Migration%20Guide%20from%201.2%20to%201.3.md)**<br/>
This document is a migration guide outlining the changes from ILCD+EPD format version 1.2 to 1.3.

**[Technical Details](/doc/guides/EPD%20Data%20Format%20–%20Technical%20Details.md)**<br/>
This document provides additional information for software developers who want to integrate support for the ILCD+EPD data format into their software applications. [(Download)](/doc/guides/EPD%20Data%20Format%20–%20Technical%20Details.docx)

## Authoritative Identifiers (UUIDs)

The ILCD data format is an object-oriented format (see [ILCD+EPD Data Format Introduction](link)). Some objects are very often reused and have a authoritative character (master data), e.g. for units, LCIA methods, background databases/versions etc. They ensure consistency across datasets.
Each object has their individual UUID. The most important UUIDs are listed here for reference. You can view or download these lists in CSV format.
All master data can be found in a dedicated [repository](https://github.com/InDataWG/ILCD-EPD-Master-Data)

| Reference Type                         | Go to Source Code                              | Viewable Table                                 |
|----------------------------------------|--------------------------------------------------|------------------------------------------------|
| Common references                      | [Source Code](./doc/identifiers/Common_references.csv)       | [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/Common_references.html)     |
| Flow properties and unit groups        | [Source Code](./doc/identifiers/Flow_properties_and_unit_groups.csv)| [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/Flow_properties_and_unit_groups.html) |
| EN15804+A1 indicators                  | [Source Code](./doc/identifiers/EN15804+A1_indicators.csv)| [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/EN15804+A1_indicators.html) |
| EN15804+A2 (EF3.0) indicators          | [Source Code](./doc/identifiers/EN15804+A2_EF3.0_indicators.csv)| [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/EN15804+A2_EF3.0_indicators.html) |
| EN15804+A2 (EF3.1) indicators          | [Source Code](./doc/identifiers/EN15804+A2_EF3.1_indicators.csv)| [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/EN15804+A2_EF3.1_indicators.html) |
| Country-specific indicators            | [Source Code](./doc/identifiers/Country-specific_indicators.csv) | [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/Country-specific_indicators.html)  |
| ecoinvent database: source data sets   | [Source Code](./doc/identifiers/BackgroundDB_SourceDatasets_ecoinvent.csv)    | [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/BackgroundDB_SourceDatasets_ecoinvent.html)  |
| GaBi database: source data sets        | [Source Code](./doc/identifiers/BackgroundDB_SourceDatasets_GaBi.csv)  | [Viewable Table](https://InDataWG.github.io/ILCD-EPD-Data-Format/gitBranches/release/v1.3/identifiers/BackgroundDB_SourceDatasets_GaBi.html) |

## Example dataset

A simple [example ILCD+EPD process dataset](./sample_data/processes/EPDv1.3_example_57a4ae65-d305-421e-b21f-a3f0c35b8abe.xml) can be found in the [sample_data](./sample_data) folder of this repository.


## Validation

### ILCD Validation Tool

In order to make sure that a given ILCD+EPD dataset is compliant with both the XML Schemas and the ILCD+EPD master data, it can be validated using the [ILCD Validation Tool](https://bitbucket.org/okusche/ilcdvalidationtool/wiki/Home), a free and Open Source desktop tool available for all major operating systems. You will need to use a validation profile specific for ILCD+EPD (see next subsection).

For developers, the underlying logic for validating ILCD+EPD data against a given validation profile is also available as an Open Source Java library: [ILCD Validation Library](https://bitbucket.org/okusche/ilcdvalidation/)

### Validation profiles

The generic profile for ILCD+EPD v1.2 for EN 15804+A1 and +A2 (EF3.0 and EF3.1) compliant data is available [here](https://repo1.maven.org/maven2/com/okworx/ilcd/validation/profiles/EPD-1.2-Generic-EN15804/2.2.0/EPD-1.2-Generic-EN15804-2.2.0.jar).

***The Validation Profiles for version 1.3 are under development.***

The profile with additionl specific rules for the [ÖKOBAUDAT](https://www.oekobaudat.de/) database is available [here](https://repo1.maven.org/maven2/com/okworx/ilcd/validation/profiles/EPD-1.2-OEKOBAUDAT/3.5.0/EPD-1.2-OEKOBAUDAT-3.5.0.jar).
