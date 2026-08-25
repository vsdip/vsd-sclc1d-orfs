# Known Issues

This is an experimental SCL C1D 1.2 µm ORFS reference flow.

The validated GCD run reaches routed ODB, extracted SPEF and final GDS.

Current limitations:

- Seven detailed-routing DRC violations remain.
- Timing is not closed at the 100 ns constraint.
- The PDK provides only two routing metal layers.
- Detailed routing may take approximately 60–70 minutes.
- Filler insertion inherits three pre-existing placement violations.
- KLayout requires the `<lef-files/>` template correction for VIA12.
- The flow is not yet tapeout-ready.

The current release is intended for education, platform bring-up and
open-source flow development.

