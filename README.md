
# ILCD-EPD-Data-Format Documentation

Welcome to the ILCD+EPD Data Format documentation. This README provides a comprehensive overview of the format, along with essential links, references, and resources.



## Documentation

- **[Change log/Release notes](./docs/changelog.md)**  
  Keep up-to-date with the latest changes, improvements, and fixes.
  
- **[Brief Introduction to the ILCD Format](./docs/introduction.md)**  
  Understand the fundamentals and structure of the ILCD data format.
  
- **Authoritative Identifiers (UUIDs)**  
  Authoritative identifiers serve as master data within the ILCD framework. They ensure consistency across datasets. 



## References



| Reference Type                         | Viewable Table                                 | Downloadable XLSX                           |
|-------------------------------------------|---------------------------------------------------|------------------------------------------------|
| References to LCIA Methods/Indicators     | [Viewable Table](./data/lcia_methods_table.html)  | [Downloadable XLSX](./data/lcia_methods.xlsx)  |
| References to Background LCA Databases    | [Viewable Table](./data/background_lca_table.html)| [Downloadable XLSX](./data/background_lca.xlsx)|
| References to Standards                   | [Viewable Table](./data/standards_table.html)     | [Downloadable XLSX](./data/standards.xlsx)     |
| References to Flow Properties and Units   | [Viewable Table](./data/flow_properties_table.html)| [Downloadable XLSX](./data/flow_properties.xlsx)|
| References to Program Operators           | [Viewable Table](./data/program_operators_table.html) | [Downloadable XLSX](./data/program_operators.xlsx) |

### Further Identifiers (UUIDs)
Further identifiers represent non-master data elements that contribute to the overall dataset.




## ILCD+EPD Guides

- **[Howto for Data Consumers](./docs/consumer_guide.md)**  
  Instructions for those consuming ILCD+EPD data, with tips on how to navigate and utilize datasets effectively.

- **[Howto for Data Generators](./docs/generator_guide.md)**  
  Guidelines for data providers on how to create and maintain ILCD+EPD compliant datasets.


## Schemas

| Schema Name | Schema Source | HTML Documentation |
|-------------|---------------|--------------------|
| EPD DataSet | [Link](./schemas/EPD_DataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/EPD_DataSet.html) |
| EPD FlowDataSet | [Link](./schemas/EPD_FlowDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/EPD_FlowDataSet.html) |
| ILCD Common DataTypes | [Link](./schemas/ILCD_Common_DataTypes.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/ILCD_Common_DataTypes.html) |
| ILCD UnitGroupDataSet | [Link](./schemas/ILCD_UnitGroupDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/ILCD_UnitGroupDataSet.html) |
| ILCD FlowPropertyDataSet | [Link](./schemas/ILCD_FlowPropertyDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/ILCD_FlowPropertyDataSet.html) |
| ILCD LCIA MethodDataSet | [Link](./schemas/ILCD_LCIA_MethodDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/ILCD_LCIA_MethodDataSet.html) |
| ILCD ContactDataSet | [Link](./schemas/ILCD_ContactDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/ILCD_ContactDataSet.html) |
| ILCD SourceDataSet | [Link](./schemas/ILCD_SourceDataSet.xsd) | [View Documentation](https://indatawg.github.io/ILCD-EPD-Data-Format/mainBranch/doc/schemadoc/ILCD_SourceDataSet.html) |





## Examples

Here are some example datasets to help you understand the implementation of ILCD+EPD format:
- **[Example 1: Dataset A](./examples/dataset_a.xml)**
- **[Example 2: Dataset B](./examples/dataset_b.xml)**


## Validation Profiles

Download the latest validation profiles to ensure your data is compliant with ILCD+EPD standards:
- [Download Validation Profile v1.0](./validation/validation_profile_v1.0.xml)
- [Download Validation Profile v2.0](./validation/validation_profile_v2.0.xml)
