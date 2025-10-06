# COMP 360 AB1: 3D Prototype Landscape Assignment

This repository contains the solution for Assignment 1: 3D Prototype Landscape generation using Godot 4.5 and GDScript.

The project successfully generates a dynamic 3D mesh based on a FastNoiseLite heightmap, meeting all technical requirements for geometry construction and texturing.

## Individual Contribution Breakdown

This section details the primary technical responsibilities handled by the two active group members over the two-week period.

| Core Task Area | Specific Contribution | Contributor |
| :--- | :--- | :--- |
| **I. Noise Generation & Image Data** | Implemented the `generate_noise_image()` function, FastNoiseLite setup (Simplex/Octaves), and `heightmap.png` file handling. | Mihir |
| **II. 3D Mesh Geometry (Vertices)** | Wrote the core `create_landscape_mesh` function, including the logic for calculating vertex positions and mapping the height from the image's red channel (`color.r`). | [Your Name] |
| **III. Mesh Indexing & UV Mapping** | Developed the `SurfaceTool` indexing logic to create the grid of triangles (quads) and calculated the necessary UV coordinates for texturing. | Mihir |
| **IV. Final Material & Aesthetics** | Handled final debugging, implemented the `add_texture_and_material` logic, and ensured the material uses the calculated vertex colors and the FastNoiseLite image as a texture (as required). | [Your Name] |
| **V. Project & Logging Management** | Initial Godot project setup, scene configuration (Camera3D, Light3D), and managing the Git repository and submission logs (`git log`, `kanban_log.md`). | [Your Name] |
| **VI. Final Submission Prep** | Final compilation of documentation and preparation of the short debugging/testing video. | Mihir |

---
## Project Technical Summary

The code adheres to the 'one more vertex row/column than pixels' rule by setting `grid_size = image_size + 1` and uses GDScript's `SurfaceTool` for efficient mesh construction. All geometry parameters are exposed as `@export` variables for testing and tuning.
