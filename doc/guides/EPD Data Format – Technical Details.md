# EPD Data Format – Details

## About this document

This document provides additional information for software developers who want to integrate support for the ILCD+EPD data format into their software applications.

## EN 15804 - Modules

The following modules according to EN 15804 are supported:

A1

A2

A3

A1-A3

A4

A5

B1

B2

B3

B4

B5

B6

B7

C1

C2

C3

C4

D

These values are binding for use in the @module attribute.

## Physical properties

Physical product or material properties can be modelled by embedding MatML (http://www.matml.org/) markup as shown in the examples below.

The following property name identifiers are currently supported for declaring non-scaling material properties (property name like „grammage“ and „gross density“ are binding; there are single spaces between multiple words):

| **property identifier** | **unit** | **description** |
| --- | --- | --- |
| *bulk density* | kg/m^3 | kilograms per cubic metre |
| *grammage* | kg/m^2 | kilograms per square metre |
| *gross density* | kg/m^3 | kilograms per cubic metre |
| *layer thickness* | m | metres |
| *productiveness* | m^2 | square metres |
| *linear density* | kg/m | kilograms per metre |
| *conversion factor to 1 kg* |  |  |

The following examples show how to express the individual properties. *(Material)* can be any text and *(Value)* the decimal value with a dot (.) as decimal separator (e.g.  *42.1*).

grammage

```xml

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr2">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr2">
         <mat:Name>grammage</mat:Name>
         <mat:Units description="kilograms per square metre" name="kg/m^2">
            <mat:Unit>
               <mat:Name>kg</mat:Name>
            </mat:Unit>
            <mat:Unit power="-2">
               <mat:Name>m</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

```

gross density

```xml

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr1">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr1">
         <mat:Name>gross density</mat:Name>
         <mat:Units name="kg/m^3" description="kilograms per cubic metre">
            <mat:Unit>
               <mat:Name>kg</mat:Name>
            </mat:Unit>
            <mat:Unit power="-3">
               <mat:Name>m</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

```

bulk density

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr3">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr3">
         <mat:Name>bulk density</mat:Name>
         <mat:Units name="kg/m^3" description="kilograms per cubic metre">
            <mat:Unit>
               <mat:Name>kg</mat:Name>
            </mat:Unit>
            <mat:Unit power="-3">
               <mat:Name>m</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

layer thickness

```xml

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr4">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr4">
         <mat:Name>layer thickness</mat:Name>
         <mat:Units name="m" description="metres">
            <mat:Unit>
               <mat:Name>m</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

```

productiveness

```xml

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr5">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr5">
         <mat:Name>productiveness</mat:Name>
         <mat:Units name="m^2" description="square metres">
            <mat:Unit power="2">
               <mat:Name>m</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

```

linear density

```xml

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr6">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr6">
         <mat:Name>linear density</mat:Name>
         <mat:Units name="kg/m" description="kilograms per metre">
            <mat:Unit>
               <mat:Name>kg</mat:Name>
            </mat:Unit>
            <mat:Unit power="-1">
               <mat:Name>m</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

```

conversion factor to 1 kg

```xml

<mat:MatML_Doc xmlns:mat="http://www.matml.org/">
   <mat:Material>
      <mat:BulkDetails>
         <mat:Name>(Material)</mat:Name>
         <mat:PropertyData property="pr7">
            <mat:Data format="float">(Value)</mat:Data>
         </mat:PropertyData>
      </mat:BulkDetails>
   </mat:Material>
   <mat:Metadata>
      <mat:PropertyDetails id="pr7">
         <mat:Name>conversion factor to 1 kg</mat:Name>
         <mat:Units name="-" description="none">
            <mat:Unit>
               <mat:Name>-</mat:Name>
            </mat:Unit>
         </mat:Units>
      </mat:PropertyDetails>
   </mat:Metadata>
</mat:MatML_Doc>

```