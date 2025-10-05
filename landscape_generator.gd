extends Node3D

# --- Export Variables ---
@export var image_size: int = 128
@export var noise_frequency: float = 0.03 # Increased detail
@export var mesh_height_scale: float = 25.0 # Increased height 
@export var mesh_xz_scale: float = 0.5    

# --- Internal Variables ---
var heightmap_image: Image # Variable to hold the loaded image data
var grid_size: int         # Size of the grid (vertices per side)


# --- Ready Function ---
func _ready():
	var generated_image: Image = generate_noise_image()
	
	if generated_image != null:
		heightmap_image = generated_image
		grid_size = heightmap_image.get_width() + 1
		print("Heightmap loaded. Grid size will be %dx%d vertices." % [grid_size, grid_size])
		
		save_image_to_disk(heightmap_image)
		
		create_landscape_mesh()
	else:
		push_error("Failed to generate heightmap image. Cannot create landscape.")


# --- Noise Generation Function (Step 1) ---
func generate_noise_image() -> Image:
	print("Generating FastNoiseLite image...")

	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX 
	noise.fractal_octaves = 4
	noise.frequency = noise_frequency

	var image = Image.create(image_size, image_size, false, Image.FORMAT_RF)

	for y in range(image_size):
		for x in range(image_size):
			var noise_value = noise.get_noise_2d(x, y)
			var color_value = (noise_value + 1.0) * 0.5
			image.set_pixel(x, y, Color(color_value, color_value, color_value))
			
	return image
	
# --- Helper Function to save the generated image
func save_image_to_disk(image: Image):
	var error = image.save_png("res://heightmap.png")
	if error != OK:
		print("Error saving image: ", error)
	else:
		print("Successfully saved heightmap.png with size %dx%d" % [image_size, image_size])


# --- Mesh Generation Function (Step 2C - Now adds Vertex Color) ---
func create_landscape_mesh():
	# 1. Create a container for the mesh
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = "LandscapeMesh"
	add_child(mesh_instance)

	# 2. Use SurfaceTool to build the geometry data
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Define color stops for the gradient (from low height to high height)
	var color_grass = Color("#4a6a3b") # Green/earth color for low areas
	var color_rock = Color("#808080")  # Grey color for mid-height
	var color_snow = Color("#ffffff")  # White color for peaks
	
	# 3. Generate Vertices, UVs, and COLORS
	for z in range(grid_size):
		for x in range(grid_size):
			
			# A. Calculate Position (X, Y, Z)
			var x_pos = float(x) * mesh_xz_scale
			var z_pos = float(z) * mesh_xz_scale
			
			# B. Get Height from Image
			var image_x = clamp(x, 0, image_size - 1)
			var image_y = clamp(z, 0, image_size - 1)
			var color_pixel = heightmap_image.get_pixel(image_x, image_y)
			var pixel_value = color_pixel.r # This value is from 0.0 (valley) to 1.0 (peak)
			
			var y_height = pixel_value * mesh_height_scale
			
			# C. Calculate Vertex Color based on Normalized Height (0.0 to 1.0)
			var vertex_color: Color
			
			# TIER ADJUSTMENT: Lowering the thresholds to see more green/rock.
			if pixel_value < 0.2:
				# Bottom 20%: Mostly grass/earth
				vertex_color = color_grass.lerp(color_rock, pixel_value / 0.2)
			elif pixel_value < 0.5:
				# Mid section (20% to 50%): Mostly rock/mid-grey
				vertex_color = color_rock.lerp(color_snow, (pixel_value - 0.2) / 0.3)
			else:
				# Top 50%: Snow/Peak
				# We can also add a slight darker color for the highest peaks for contrast
				vertex_color = color_snow.lerp(color_rock, (pixel_value - 0.5) * 2.0)
				
			st.set_color(vertex_color) # <-- SET THE COLOR
			
			# D. Set Vertex Data
			var vertex_position = Vector3(x_pos, y_height, z_pos)
			
			# E. Set UV coordinates (for texture mapping)
			var u = float(x) / (grid_size - 1.0)
			var v = float(z) / (grid_size - 1.0)
			st.set_uv(Vector2(u, v))
			st.add_vertex(vertex_position)

	# 4. Generate Triangles (Indices - unchanged)
	for z in range(image_size):
		for x in range(image_size):
			var v0 = z * grid_size + x
			var v1 = z * grid_size + (x + 1)
			var v2 = (z + 1) * grid_size + (x + 1)
			var v3 = (z + 1) * grid_size + x

			st.add_index(v0)
			st.add_index(v1)
			st.add_index(v3)

			st.add_index(v3)
			st.add_index(v1)
			st.add_index(v2)

	# 5. Finalize the Mesh
	st.generate_normals()
	var array_mesh = st.commit()

	# 6. Apply the Mesh to the MeshInstance3D
	mesh_instance.mesh = array_mesh
	
	# Optional: Center the mesh for easier viewing
	mesh_instance.global_position = Vector3(
		-image_size * mesh_xz_scale / 2.0, 
		0, 
		-image_size * mesh_xz_scale / 2.0
	)
	
	# 7. Add Material and Texture (Step 3)
	add_texture_and_material(mesh_instance)
	
	print("3D Landscape Mesh created successfully!")

# --- Texture Function (Step 3 - Finalized: Now uses Vertex Color) ---
func add_texture_and_material(mesh_instance: MeshInstance3D):
	# We no longer apply the heightmap as a texture, but we enable vertex colors
	
	var material = StandardMaterial3D.new()
	
	# Crucial step: Tell the material to use the colors we set on the vertices (grass/rock/snow)
	material.vertex_color_use_as_albedo = true 
	
	# Improve the look with PBR properties
	material.roughness = 0.8  # Make it less shiny (more like rough snow/rock)
	material.metallic = 0.1   # Keep it non-metallic
	
	# Optional: Enable texture for shadows/details if needed, but not necessary for color
	# material.albedo_texture = ImageTexture.create_from_image(heightmap_image) 
	
	mesh_instance.material_override = material
	print("Material finalized with height-based coloring.")
