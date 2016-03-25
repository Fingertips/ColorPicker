# Persistent Color Picker Help

Persistent Color Picker turns the default Mac OS X Color Picker into a stand-alone utility with copy and paste support for various code formats.

## Copy and Paste Formats

You can choose the format to use from the “Copy As…” item in the “Edit” menu. The current values for the selected format are shown in the copy value preview bar in the bottom half of the window.

You can paste colors in any of the supported formats.

When any of the “NSColor” formats are selected, the current color is always converted to the “Generic RGB” color space. The other formats are always converted to the “sRGB IEC 61966-2-1” color space.

## Color Conversion

To reproduce a color accurately, its representation should not only consist of its component values (such as “red”, “green”, and “blue” for the RGB [color model](https://en.wikipedia.org/wiki/Color_model)), but should also contain a reference to a specific [color space](https://en.wikipedia.org/wiki/Color_space).

What makes this somewhat confusing, is that the color space is almost never an explicit value when a color representation is formatted as code. The reason for this is that most platforms define the color space implicitly.

On the web, all colors representations are in the sRGB color space. This is why the HTML and CSS formats are converted to and from “sRGB IEC 61966-2-1” when you copy or paste.

On iOS, all colors and any content is assumed to be in the sRGB color space as well. This is why the “UIColor” formats are converted to and from “sRGB IEC 61966-2-1” when you copy or paste.

Mac OS X includes the ColorSync color management API which allows conversion between color models and color spaces. However, the recommended way to represent colors in code is with “colorWithCalibrated” which uses the “Generic RGB” color space. This is why the “NSColor” formats are converted to and from “Generic RGB” when you copy or paste.

## RGB Sliders

Most of the Color Picker panels default to the “Generic RGB” color space. This can be confusing when you’re working with CSS, HTML, or iOS code where colors are assumed to use the sRGB color space instead.

For example, when you choose a color from the “Color Wheel” panel, and then switch to the “RGB Sliders” in the “Color Sliders” panel, the values of the “Red”, “Green”, and “Blue” sliders as well as the value in the “Hex Color” field won’t match the values you’ll see in the copy value preview bar. 

You can make these fields show the correct values when you click the gear button at the top of the panel, and then choose the “sRGB IEC 61966-2-1” color space from the dropdown.

Since this is a bit cumbersome, we’ve added a shortcut button in the copy value preview bar that you can use to quickly convert the current color to the color space of the selected “Copy As…” format. This button is disabled when the current color is already in the same color space as the selected code format.
