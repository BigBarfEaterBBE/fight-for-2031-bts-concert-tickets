shader_type canvas_item;

uniform vec4 color : source_color;

void fragment() {
    // Find the distance from the center of the square (0.5, 0.5)
    vec2 center = UV - vec2(0.5);
    float dist = length(center);

    // Define the radius of the circle (e.g., 0.48 for a slight border)
    float radius = 0.48;

    // If the distance is less than the radius, draw the color
    if (dist < radius) {
        COLOR = color;
    } else {
        // Otherwise, make it transparent (invisible)
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}