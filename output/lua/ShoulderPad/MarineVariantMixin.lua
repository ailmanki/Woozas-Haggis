
MarineVariantMixin.networkVars =
{
	shoulderPadIndex = string.format("integer (0 to %d)",  64),
	marineType = "enum kMarineVariantsBaseType",
	variant = "enum kMarineVariants"
}
--Shared.LinkClassToMap("MarineVariantMixin", MarineVariantMixin.kMapName, networkVars)