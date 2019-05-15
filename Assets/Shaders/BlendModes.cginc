#ifndef BLEND_MODES_INCLUDED
#define BLEND_MODES_INCLUDED

inline fixed blendOverlay(fixed base, fixed blend)
{
	return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
}


inline fixed3 blendOverlay(fixed3 base, fixed3 blend)
{
	return fixed3(
		blendOverlay(base.r, blend.r),
		blendOverlay(base.g, blend.g),
		blendOverlay(base.b, blend.b)
	);
}

inline fixed3 blendHardLight(fixed3 base, fixed3 blend)
{
	return blendOverlay(blend, base);
}


inline fixed3 blendOverlay(fixed3 base, fixed3 blend, fixed opacity)
{
	return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}

inline fixed3 blendHardLight(fixed3 base, fixed3 blend, fixed opacity)
{
	return (blendOverlay(blend, base) * opacity + base * (1.0 - opacity));
}

#endif // UNITY_CG_INCLUDED