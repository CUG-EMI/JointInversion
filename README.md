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

- `trueandinitialmodel`: true and initial model files (.ws/.rho), including their mesh geometry.
- `Inputdata`: noisy input data (.dat); station coordinates and MT periods are embedded in the data files. `synthetic_MT_16x16_5percent.dat` is the computed 16×16 survey (256 sites, 500 m spacing, coordinates −3750…3750 m, 18 frequencies). `synthetic_MT_5percent.dat` now aliases the 8×8 data, matching the author-confirmed figure survey. The 8×8 alternative is explicitly named.
- `separate`: selected density, susceptibility and resistivity models.
- `joint`: selected complete density, susceptibility and resistivity models. Joint MT is 5BLOCKs_NLCG_050-1227-j2.rho recovered from the original archive; both reviewed slices match within 5e-5 in log10 resistivity.

### Model C corrections and survey clarification

Based on the author's clarification, the resistivity entries in the published Table 1 are incorrect. From left to right, blocks A, B and C are all **10 Ω·m**, while blocks D and E are both **500 Ω·m**. The homogeneous background and starting resistivity model are **100 Ω·m**. Only resistivity assignments are corrected; density and susceptibility assignments are unchanged. Both MT surveys have been recomputed using the corrected true model, followed by the stated noise and error calculations.

The author confirms that the inversion-result figures presented in the article used an **8×8 MT survey (64 stations)**. The main text incorrectly describes a **16×16** survey and also gives **289 stations**. A 16×16 station grid has **256 stations**, whereas 289 would correspond to 17×17. This release supplies both survey options:

| Survey | Stations | Spacing | X/Y station range | File |
|---|---:|---:|---|---|
| 8×8, corresponding to the author's figure-survey clarification | 64 | 1000 m | −3500 to 3500 m | `synthetic_MT_8x8_5percent.dat` |
| 16×16, additional comparison option | 256 | 500 m | −3750 to 3750 m | `synthetic_MT_16x16_5percent.dat` |

Both surveys contain 18 logarithmically spaced frequencies from 0.001 to 1000 Hz and all four impedance components. The stations lie within the ±4 km core region; this release does not use the 1600 m spacing stated in the article. The default file `synthetic_MT_5percent.dat` is identical to the 8×8 file.

This clarification of the historical figure survey comes from the author. The newly supplied synthetic data have been recomputed; the retained historical inversion results have NOT been rerun against the corrected data. The known high-frequency numerical-accuracy limitation remains applicable. The paper table/text correction does not by itself resolve that limitation.

## 02_Field_Data_Yanggao

Field gravity and magnetic observations are confidential and are deliberately excluded. Only their initial models and inversion results are included. The MT input data are retained together with separate and joint inversion models, settings and logs.

For the field joint inversion, `Paper_Selected_Result_iter059` is the set selected for the manuscript figures; `Final_Computational_Checkpoint` preserves the last available computational checkpoint.

