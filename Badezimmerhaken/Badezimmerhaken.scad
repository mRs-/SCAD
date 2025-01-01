// Created by Marius Landwehr
// License: Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License

include <../BOSL2/std.scad>

/* [Hook Variables] */
// width of the hook in mm
hookWidth = 30.0;
// length of the hook in mm
hookLength = 60.0;
// thickness of the hook in mm
hookThickness = 4.0;
// top rounding in mm
hookRounding = 15.0;
// the size of the hook prism at the tip
hookPrismTop = 4.0;
// the size of the hook prism at the bottom
hookPrismBottom = 6.0;
// the factor hook shifting factor. How steep should be the angle?
hookShiftFactor = 4.0;

/* [Mounting Hole Sizes] */
// The size between the mounting holes.
holesSpacing = 25.0;
// Move the holes in the y offset so it's easier to reach the mounting holes.
holeYOffset = 5.0;
// the bottom hole radius
holeRadiusBottom = 2.0;
// the top hole radius
holeRadiusTop = 3.5;

/* [Others] */
$fn=50;

module basePlate()  {
    difference() {
        cuboid([hookWidth, hookLength, hookThickness],
                anchor=BOT+CENTER, 
                rounding=hookRounding, 
                edges=[BACK+RIGHT, BACK+LEFT]);

        fwd((holesSpacing / 2) - holeYOffset)
        cylinder(h = hookThickness, r1 = holeRadiusBottom, r2 = holeRadiusTop);

        back((holesSpacing / 2) + holeYOffset)
        cylinder(h = hookThickness, r = holeRadiusBottom, r2 = holeRadiusTop);
    }
}
 
module hanger() {
    up(hookThickness)
    fwd(hookLength / 2 - hookPrismBottom / 2)
    prismoid(size1 = [hookWidth, hookPrismBottom], 
            size2 = [hookWidth/2, hookPrismTop],
            h = hookLength/3,
            shift= [0,hookLength/hookShiftFactor]
            );
}

union() {
    basePlate();
    hanger();    
}
