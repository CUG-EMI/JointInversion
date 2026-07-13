# Joint inversion supplementary data

This package is organized into synthetic and field-data examples. The original source directories were not modified.

## 01_Synthetic_Data

### Model_A_Depth_Weighting

Synthetic depth-weighting test. The archived files include the synthetic gravity input, true and homogeneous initial density models, and the four final models used by the plotting script:

- `final_no_weighting.dat`
- `final_Zhdanov_weighting.dat`
- `final_conventional_depth_weighting.dat`
- `final_improved_depth_weighting.dat`

### Model_B_Norm_Weighting

Synthetic norm-weighting test. The archived files include the synthetic magnetic input, true and homogeneous initial susceptibility models, and the four final models used by the plotting script:

- `final_L0_norm.dat`
- `final_L1_norm.dat`
- `final_L2_norm.dat`
- `final_elastic_net_L0_L2_alpha0.6.dat`

### Model_C_Joint_Inversion

Five-block synthetic test. It contains synthetic gravity, magnetic and MT inputs; true and initial models; and the final separate and joint inversion results for density, susceptibility and resistivity.

The final files are those explicitly selected by `PlotEMG_5b_newread.m`: iteration 050 for the separate inversion and iteration 010 for the joint inversion. The current archived final gravity/magnetic models have a 40 x 40 x 20 mesh, whereas the manuscript describes the conceptual/core grid as 40 x 40 x 12. This source-version difference should be checked before public release.

## 02_Field_Data_Yanggao

Field gravity and magnetic observations are confidential and are deliberately excluded. Only their initial models and inversion results are included. The MT input data are retained together with separate and joint inversion models, settings and logs.

For the field joint inversion, `Paper_Selected_Result_iter059` is the set selected for the manuscript figures; `Final_Computational_Checkpoint` preserves the last available computational checkpoint.

