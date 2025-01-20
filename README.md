# ILCD-EPD Data Format Documentation

Welcome to the ILCD+EPD Data Format documentation. This README provides a comprehensive overview of the format, along with essential links, references, and resources.

## Documentation

- **[Change log/Release notes](doc/CHANGES.txt)**  
  Keep up-to-date with the latest changes, improvements, and fixes.

- **[ TODO Brief Introduction to the ILCD Format](./docs/introduction.md)**  
  Understand the fundamentals and structure of the ILCD data format.

## Authoritative Identifiers (UUIDs)

Authoritative identifiers serve as master data within the ILCD framework. They ensure consistency across datasets.

| Reference Type                         | Go to Source Code                              | Viewable Table                                 |
|----------------------------------------|--------------------------------------------------|------------------------------------------------|
| ecoinvent database: source data sets   | [Source Code](./doc/identifiers/BackgroundDB_SourceDatasets_ecoinvent.csv)    | [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/BackgroundDB_SourceDatasets_ecoinvent.html)  |
| GaBi database: source data sets        | [Source Code](./doc/identifiers/BackgroundDB_SourceDatasets_GaBicsv)  | [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/BackgroundDB_SourceDatasets_GaBi.html) |
| Common references                      | [Source Code](./doc/identifiers/Common_references.csv)       | [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/Common_references.html)     |
| Country-specific indicators            | [Source Code](./doc/identifiers/Country-specific_indicators.csv) | [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/Country-specific_indicators.html)  |
| EN15804+A1 indicators                  | [Source Code](./doc/identifiers/EN15804+A1_indicators.csv)| [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/EN15804+A1_indicators.csv) |
| EN15804+A2 (EF3.0) indicators          | [Source Code](./doc/identifiers/EN15804+A2_EF3.0_indicators.csv)| [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/EN15804+A2_EF3.0_indicators.html) |
| EN15804+A2 (EF3.1) indicators          | [Source Code](./doc/identifiers/EN15804+A2_EF3.1_indicators.csv)| [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/EN15804+A2_EF3.1_indicators.html) |
| Flow properties and unit groups        | [Source Code](./doc/identifiers/Flow_properties_and_unit_groups.csv)| [Viewable Table](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/identifiers/Flow_properties_and_unit_groups.html) |


## ILCD+EPD Guides

- **[Howto for Data Consumers](./docs/consumer_guide.md)**  
  Instructions for those consuming ILCD+EPD data, with tips on how to navigate and utilize datasets effectively.

- **[Howto for Data Generators](./docs/generator_guide.md)**  
  Guidelines for data providers on how to create and maintain ILCD+EPD compliant datasets.

## Schemas

| Schema Name | Go to Source Code | HTML Documentation in the Browser |
|-------------|-----------------------|-----------------------------------|
| EPD DataSet | [Souce Code](./doc/schemadoc/EPD_DataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/EPD_DataSet.html) |
| EPD FlowDataSet | [Souce Code](./doc/schemadoc/EPD_FlowDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/EPD_FlowDataSet.html) |
| ILCD Common DataTypes | [Souce Code](./doc/schemadoc/ILCD_Common_DataTypes.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/ILCD_Common_DataTypes.html) |
| ILCD UnitGroupDataSet | [Souce Code](./doc/schemadoc/ILCD_UnitGroupDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/ILCD_UnitGroupDataSet.html) |
| ILCD FlowPropertyDataSet | [Souce Code](./doc/schemadoc/ILCD_FlowPropertyDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/ILCD_FlowPropertyDataSet.html) |
| ILCD LCIA MethodDataSet | [Souce Code](./doc/schemadoc/ILCD_LCIA_MethodDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/ILCD_LCIA_MethodDataSet.html) |
| ILCD ContactDataSet | [Souce Code](./doc/schemadoc/ILCD_ContactDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/ILCD_ContactDataSet.html) |
| ILCD SourceDataSet | [Souce Code](./doc/schemadoc/ILCD_SourceDataSet.html) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/gitBranches/testMain/schemadoc/ILCD_SourceDataSet.html) |

## TODO Examples

Here are some example datasets to help you understand the implementation of ILCD+EPD format:
- **[Example 1: Dataset A](./examples/dataset_a.xml)**
- **[Example 2: Dataset B](./examples/dataset_b.xml)**

## TODO Validation Profiles

Download the latest validation profiles to ensure your data is compliant with ILCD+EPD standards:
- [Download Validation Profile v1.0](./validation/validation_profile_v1.0.xml)
- [Download Validation Profile v2.0](./validation/validation_profile_v2.0.xml)
