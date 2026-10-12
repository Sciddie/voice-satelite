// v3.6 BODY FIX: marking jig for the microSD relief window in the right side wall (= the USB-notch wall).
// Registers in the existing USB notch (floor, back face, 45 deg roof) from outside; plate lies on the outer wall face.
//
// Diese Datei hing an voicesat_case v3.6 (include eines lokalen Pfads). v3.6 ist
// absichtlich nicht im Repo. voicesat_case.scad daneben ist v3.7: die rechte Wand
// liegt 3 mm weiter außen, ein Neutrendern ergibt nicht die mitgelieferte STL.
// Druckvorlage: ../stl/voicesat-sd-schablone.stl und ../3mf/voicesat-sd-schablone.3mf
// (Nachrüstung nur für ein schon gedrucktes v3.6-Gehäuse; bei v3.7 unnötig).
// include <voicesat_case_v3.6.scad>
part = "none";
jig_part = "print";              // "print" (on the bed) or "placed" (in body coordinates)
c   = 0.15;                      // fit clearance per side in the notch
td  = 1.2;                       // tongue depth into the notch (stays outside the HAT's USB receptacle at x 163.5)
pt  = 1.6;                       // plate thickness
// notch (v3.6 body coords): y from the front face -9 to the back face ny1, floor nz0, roof z = nz1 + (ny1 - y)
ny1 = usb_yc + usb_plug[1]/2 + usb_margin;          // 1.5
nz0 = usb_z - usb_plug[0]/2 - usb_margin;           // 57.7
nz1 = usb_z + usb_plug[0]/2 + usb_margin;           // 69.7
// SD window (card at the final Pi position: y 9.4..11.0, z 53.5..64.5, 3.2 mm proud) + 1 mm margin
sd = [pi_front_y - 1.6 - 1.0, pi_front_y + 1.0, board_top - pcb_h + 7 - 1.0, board_top - pcb_h + 18 + 1.0];   // y0 y1 z0 z1
echo(str("NOTCH back face y=", ny1, " floor z=", nz0, " flat-top z=", nz1, " ; SD WINDOW y ", sd[0], "..", sd[1], " z ", sd[2], "..", sd[3]));
echo(str("FROM NOTCH: window starts ", sd[0]-ny1, " behind the notch back face, ", sd[1]-sd[0], " long (y); bottom ", nz0-sd[2], " below the notch floor, top ", sd[3]-nz0, " above it; height ", sd[3]-sd[2]));
echo(str("FROM BODY: front face (y=-9) -> window ", sd[0]+9, "..", sd[1]+9, " ; rim (z=", H_tub, ") -> window ", H_tub-sd[3], "..", H_tub-sd[2], " below the rim"));
py0 = -recess + 0.5;  py1 = sd[1] + 5;  pz0 = sd[2] - 5;  pz1 = nz1 + (ny1 - py0) - 3;
module jig_placed() {
  difference() {
    union() {
      // plate on the outer face x = W .. W+pt
      translate([W, py0, pz0]) cube([pt, py1-py0, pz1-pz0]);
      // tongue in the notch (x W-td .. W), profile = notch minus c
      intersection() { translate([W-td-1, py0, pz0]) cube([td+2, py1-py0, pz1-pz0]);   // tongue never overhangs the plate
      translate([W-td, 0, 0]) rotate([90,0,90]) linear_extrude(td+0.01)
        polygon([[py0, nz0+c], [ny1-c, nz0+c], [ny1-c, nz1-c*sqrt(2)+c], [py0, nz1+(ny1-py0)-c*sqrt(2)]]); }
    }
    // window = exact slot outline at the wall face (x=W), bevelled 45 deg outwards so a pencil/scriber reaches the wall
    hull() { translate([W-0.01, sd[0], sd[2]]) cube([0.01, sd[1]-sd[0], sd[3]-sd[2]]);
             translate([W+pt, sd[0]-pt, sd[2]-pt]) cube([0.02, sd[1]-sd[0]+2*pt, sd[3]-sd[2]+2*pt]); }

  }
}
if (jig_part == "placed") jig_placed();
if (jig_part == "print") difference() {   // outer face on the bed, tongue up; label engraved 0.5 into the top (wall-contact) face
  multmatrix([[0,0,1,0],[0,1,0,0],[-1,0,0,W+pt],[0,0,0,1]]) jig_placed();
  translate([pz0+2.0, (py0+sd[0])/2+0.5, pt-0.5]) rotate([0,0,90]) linear_extrude(1) text("SD v3.6", size=2.6, halign="center", font="Liberation Sans:style=Bold");
}
