// Created by Marius Landwehr
// License: Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License

include <../BOSL2/std.scad>

/* [Box Variables] */
// items shown
itemsShown="both"; // [both,box,lid]
// the amount of pan rows in a column
panRows = 6; // [1:1:20]
// the amount of colums for the whole box
panColumns = 2;// [1:1:20]

/* [Pan Sizes] */
// the width of a single pan in cm
panWidth = 16.0;
// the length of a single pan in cm
panLength = 19.0;
// the height of a single pan in cm
panHeight = 8.2;

/* [Clip Variables] */
// the width of the close clip
clipWidth = 12.0;
// the length of the close clip
clipLen = 0.5;
// the height of the close clip
clipHeight = 1.5;

/* [Others] */
// the width of the outer border
borderWidth = 2;

width = panWidth+1;
length = panLength+1;
height = panHeight+2.8;
lengthWithoutBorders = length*panColumns;
totalLength = (length*panColumns)+(borderWidth*2);
totalWidth = (width*panRows)+(borderWidth*2);

module panHolder() {
    outerPanCube = [width, length, height];
    insidePanCube = [panWidth, panLength, panHeight];
    for(i = [0:panRows - 1]) {
        for(b = [0:panColumns -1]) {
            translate([i * width, b * length, 0]) union() {
            difference() {
                cube(outerPanCube);
                translate([(length-panLength)/2,(width-panWidth)/2,3]) cube(insidePanCube);
            };
            }
        }
    }
}

module outerCasing() {
    translate([-borderWidth,-borderWidth,0]) difference() {
        hull() {
            cubeSize = borderWidth*2;
            translate ([0, length*panColumns, 0]) cube([cubeSize,cubeSize,height]);
            translate ([width*panRows, length*panColumns, 0]) cube([cubeSize,cubeSize,height]);
            translate ([borderWidth, borderWidth, 0]) cylinder (height, borderWidth, borderWidth, $fn=50);
            translate ([totalWidth-borderWidth, borderWidth, 0]) cylinder (height, borderWidth, borderWidth, $fn=50);
        }
        translate([borderWidth,borderWidth,0]) cube([(width*panRows), (length*panColumns), height+1]);
    }
}

module lid() {
    lidHeight = 9;
    lidWidth = totalWidth+3.6;
    lidBorder = borderWidth+1;
    lidLen = totalLength +2;
    
    difference() {
        translate([-lidBorder,-lidBorder,height-4.3])
        cuboid(
            [lidWidth, lidLen, lidHeight], rounding=2,
            edges=[FWD+RIGHT, FWD+LEFT],
            $fn=50
        );
        translate([-lidBorder,-lidBorder+0.7,height-7])
        cuboid(
            [lidWidth-2, lidLen, lidHeight+2], rounding=2,
            edges=[FWD+RIGHT, FWD+LEFT],
            $fn=50
        );
    }

    for (i = [1:1:panColumns-1]) {
        support = [-(lidWidth/2)-lidBorder, -(totalLength/2)+(length*i), panHeight];
        translate(support)
        cube([lidWidth, 1, 1]);
    }
}

module hingeLeft() {
    spacingBack = 1.4;
    cylRadius1 = 0.8;
    positionZ = panHeight-0.2;
    translate([(borderWidth*-1)-cylRadius1,(length*panColumns)-spacingBack,positionZ]) 
    rotate([0,90,0]) 
    cylinder(cylRadius1, 2.5, 2.5, $fn=50, false);

    cylRadius2 = cylRadius1*2;
    translate([(borderWidth*-1)-cylRadius1-cylRadius2,(length*panColumns)-spacingBack,positionZ]) 
    rotate([0,90,0]) 
    cylinder(cylRadius2, 2, 2, $fn=50, false);
}

module hingeRight() {
    spacingBack = 1.4;
    positionZ = panHeight-0.2;
    cylRadius1 = 0.8;
    translate([((width*panRows)+borderWidth),(length*panColumns)-spacingBack, positionZ]) 
    rotate([0,90,0]) 
    cylinder(cylRadius1, 2.5, 2.5, $fn=50, false);

    cylRadius2 = cylRadius1*2;
    translate([((width*panRows)+borderWidth+cylRadius1),(length*panColumns)-spacingBack, positionZ]) 
    rotate([0,90,0]) 
    cylinder(cylRadius2, 2, 2, $fn=50, false);
}

module clip(clipWidth = clipWidth, clipLen = clipLen, clipHeight = clipHeight) {
    rotate([0,90,0])
    hull() {
        cube([clipHeight,clipLen,clipWidth]);
        translate([clipLen,-clipLen,0]) cylinder(clipWidth, clipLen, clipLen, $fn=50, false);
        translate([clipHeight-clipLen, -clipLen,0]) cylinder(clipWidth, clipLen, clipLen, $fn=50, false);
    }
}

module completeLid() {
    union() {
        right(1)
        up(2)
        // difference() {
            lid();
            color("Red")
            back(lengthWithoutBorders/2)
            // back(totalWidth/2-9.5)
            up(height-3)
            left((totalWidth+12)/2)
            rotate([0,90,0]) 
            cylinder(totalWidth+12, 2.2, 2.2, $fn=50, false);
        // }
        rot(180)
        left((clipWidth/2)-2)
        up(height - 4.5)
        back((totalLength/2)+3)
        clip();

        rot(180)
        left(-2)
        up(height - 2.5)
        back((totalLength/2)+5)
        cuboid(
            [30, 3, 3], rounding=2,
            edges=[BACK+RIGHT, BACK+LEFT],
            $fn=50
        );
    }
}

if (itemsShown == "both" || itemsShown == "box") {
    translate([-(totalWidth/2), -(totalLength/2),0]) 
    union() {
        translate([(totalWidth/2)-(clipWidth/2)-borderWidth, -borderWidth, height - 2.55]) clip();
        outerCasing();
        panHolder();
        hingeLeft();
        hingeRight();
    }
}

if (itemsShown == "both" || itemsShown == "lid") {
    union() {
        // yrot(180)
        // back(totalLength+borderWidth+4)
        // down(height+2.2)
        // right(borderWidth*2)
       // completeLid();
    }
}