# COMP 360 AB1: 3D Procedural Landscape Generator

This project was completed using an iterative, experimental approach where the group first developed multiple independent solutions for the core components (Noise, Geometry, Material) before integrating the most successful versions into the final submission.

The final system uses dynamic mesh generation in Godot 4.5 based on a FastNoiseLite heightmap.

## Individual Contribution Breakdown (6 Members)

This table outlines the primary area of specialization and the specific component each team member was responsible for mastering, testing, and ultimately contributing to the final integrated solution.

| Core Component | Specialization & Key Contribution | Contributor |
| :--- | :--- | :--- |
| **I. Noise Function Mastery** | Led the exploration and implementation of different FastNoiseLite settings (Simplex vs. Cellular) and optimized the `fractal_octaves` and `frequency` for the best "natural-looking" data source. | **Mihir** |
| **II. Core Heightmap Data Pipeline** | Implemented the final `generate_noise_image` function, including normalization (mapping $[-1, 1]$ to $[0, 1]$) and managing the image resource creation and disk saving. | **Rahool** |
| **III. Vertex Position Mapping** | Developed the initial geometry construction and specialized in translating the 2D heightmap data to 3D vertex Y-positions via the `color.r` channel. | **Faneesh** |
| **IV. Mesh Indexing & Quads** | Mastered the crucial `SurfaceTool` logic for connecting vertices with triangle indices (quad formation) and ensuring no gaps or seams appeared in the final mesh. | **Hayden** |
| **V. Material & Aesthetic Grading** | Developed the final look by implementing the height-based vertex color gradient system and ensuring the final material blended this color with the required FastNoiseLite image texture. | **Satveer** |
| **VI. UV Coordination & Project Logging** | Focused on calculating the accurate UV coordinates for texture wrapping and managed the **Git repository**, `README.md`, and **Kanban logging** of project progress. | **Rohit** |

---
## Technical Summary

The final integrated solution adheres to all assignment specifications:
* Generates a 2D image using FastNoiseLite and multiple octaves.
* Creates a grid of 3D quads where the number of vertices is correctly set to **one more row/column** than the pixel dimensions.
* Uses the **red channel** of the noise image to control vertex height.
* Successfully displays the FastNoiseLite image as a texture over the generated geometry.

* ## Different Outputs for Individual Trials

<img width="1914" height="1034" alt="image" src="https://github.com/user-attachments/assets/d8d199fd-e010-454d-b96d-ceed92e6f6a4" />

<img width="1610" height="979" alt="image" src="https://github.com/user-attachments/assets/3dc2336b-c2bc-43fd-b4d0-d66ce2ea1462" />

<img width="2560" height="1440" alt="image" src="https://github.com/user-attachments/assets/bfbfc9bd-f602-4615-91f5-9295149129a1" />







