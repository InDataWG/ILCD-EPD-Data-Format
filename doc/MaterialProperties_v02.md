Document version 0.3 - 18.09.2024

# Material properties to be used in the ILCD+EPD data format

The following material properties are supported for declaring non-scaling material properties (for the identifiers, there are single spaces between multiple words):

| **property** | **Property identifier** | **Unit** | **Comments** |
| --- | --- | --- | --- |
| bulk density | bulk density | kg/m^3 |  |
| grammage | grammage | kg/m^2 |  |
| gross density | gross density | kg/m^3 |  |
| layer thickness | layer thickness | m |  |
| productiveness | productiveness | m^2 |  |
| linear density | linear density | kg/m |  |
| weight per piece | weight per piece | kg | Piece: certain amount of a material or substance that forms a self-limited whole (and has a commercially available shape, dimension) |
| conversion factor to 1 kg | conversion factor to 1 kg | - | This can be used if no other property can be given due to the nature of the product. <br> The amount of the declared unit (M) is divided by the conversion factor (f), the result is the mass:  M / f = m [kg]|
