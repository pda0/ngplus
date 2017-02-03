# NGPlus
NGPlus a project for the implementation of modern Delphi features in Free Pascal. The results of this project will be proposed for inclusion to the Free Pascal, and the tests will be moved in fp_cross_tests.

# Nearest goals

- Switch RTL units to OBJFPC mode. (almost done)
- Add RTL's IFDEFs (FPU / SYSINLINE / etc). (almost done)
- Refactor System.Hash unit to allow engines can be connected as external units.

# Todo
- More tests for T*StringHelper.CopyTo, because delphi version have no range checks but my one have.
- More tests for T*StringHelper.DeQuotedString (empty, invalid, double quotes at start, doublequoted)
