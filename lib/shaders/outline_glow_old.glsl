vec4 resultCol;
extern vec3 stepSize;

vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
{
	// get color of pixels:
	vec4 kernel =  texture2D(texture, texturePos).rgba;
	number red = 4.0 * kernel.x;
	number green = 4.0 * kernel.y;
	number blue = 4.0 * kernel.z;
	number alpha = 4.0 * kernel.w;

	kernel = texture2D(texture, texturePos + vec2(stepSize.x, 0.0f)).rgba;  // right
	red -= kernel.x;
	green -= kernel.y;
	blue -= kernel.z;
	alpha -= kernel.w;

	kernel = texture2D(texture, texturePos + vec2(-stepSize.x, 0.0f)).rgba;  // left
	red -= kernel.x;
	green -= kernel.y;
	blue -= kernel.z;
	alpha -= kernel.w;

	kernel = texture2D(texture, texturePos + vec2(0.0f, stepSize.y)).rgba;  // down
	red -= kernel.x;
	green -= kernel.y;
	blue -= kernel.z;
	alpha -= kernel.w;

	kernel = texture2D(texture, texturePos + vec2(0.0f, -stepSize.y)).rgba;  // up
	red -= kernel.x;
	green -= kernel.y;
	blue -= kernel.z;
	alpha -= kernel.w;

	// calculate resulting color
	// resultCol = vec4(stepSize.z, stepSize.z, stepSize.z / 2.0, alpha);
	resultCol = vec4(
		(stepSize.z + red * (1 - stepSize.z)),
		(stepSize.z + green  * (1 - stepSize.z)),
		(stepSize.z + blue * (1 - stepSize.z)) * 0.25,
		alpha);

	// return color for current pixel
	return resultCol;
}
